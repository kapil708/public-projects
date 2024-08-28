import 'dart:convert';
import 'dart:developer';

import 'package:graphql/client.dart';
import 'package:shopifydemo/models/product.dart';
import 'package:shopifydemo/models/shopify_storage.dart';
import 'package:shopifydemo/models/user.dart';

import '../models/category.dart';
import 'shopify_query.dart';

class ShopifyService {
  ShopifyService() : super() {
    client = getClient();
  }

  late GraphQLClient client;

  String domain = "https://tulsiresin.myshopify.com";
  String accessToken = "dbcf47543d082f0196eafad5c6174239";
  ShopifyStorage shopifyStorage = ShopifyStorage();

  GraphQLClient getClient() {
    final httpLink = HttpLink('$domain/api/graphql');
    final authLink = AuthLink(
      headerKey: 'X-Shopify-Storefront-Access-Token',
      getToken: () async => accessToken,
    );
    return GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(httpLink),
    );
  }

  void printLog(val) {
    log(val);
  }

  Future<List<Category>> getCategoriesByCursor({List<Category>? categories, String? cursor, page = 1}) async {
    try {
      printLog("::: getCategoriesByCursor");

      const nRepositories = 50;
      var variables = <String, dynamic>{'nRepositories': nRepositories};
      if (cursor != null) {
        variables['cursor'] = cursor;
      }

      final options = QueryOptions(
        document: gql(ShopifyQuery.readCollections),
        variables: variables,
      );
      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      var list = categories ?? <Category>[];

      for (var item in result.data!['shop']['collections']['edges']) {
        var category = item['node'];

        list.add(Category.fromJsonShopify(category));
        printLog("::: category : $category");
      }

      if (result.data?['shop']?['collections']?['pageInfo']?['hasNextPage'] ?? false) {
        var lastCategory = result.data!['shop']['collections']['edges'].last;
        String? cursor = lastCategory['cursor'];
        if (cursor != null) {
          printLog('::::getCategories shopify by cursor $cursor');
          return await getCategoriesByCursor(categories: list, cursor: cursor);
        }
      }
      return list;
    } catch (e) {
      return categories ?? [];
    }
  }

  Future<List<Product>?> fetchProductsByCategory({
    categoryId,
    tagId,
    page = 1,
    minPrice,
    maxPrice,
    orderBy,
    lang,
    order,
    attribute,
    attributeTerm,
    featured,
    onSale,
    //ProductModel? productModel,
    listingLocation,
    userId,
    nextCursor,
    String? include,
    String? search,
    limit,
  }) async {
    //printLog('::::request fetchProductsByCategory with category id $categoryId search:$search');
    //printLog('::::request fetchProductsByCategory with cursor ${shopifyStorage.cursor}');

    /// change category id
    if (page == 1) {
      shopifyStorage.cursor = '';
      shopifyStorage.hasNextPage = true;
    }

    //printLog('fetchProductsByCategory with shopifyStorage ${shopifyStorage.toJson()}');

    try {
      var list = <Product>[];

      if (!shopifyStorage.hasNextPage!) {
        return list;
      }

      var currentCursor = shopifyStorage.cursor;

      printLog(":::: fetchProductsByCategory cursor : $currentCursor");

      const nRepositories = 50;
      final options = QueryOptions(
        document: gql(ShopifyQuery.getProductByCollection),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, dynamic>{
          'nRepositories': nRepositories,
          'categoryId': categoryId,
          'pageSize': limit ?? 20,
          'query': search ?? '',
//          'sortKey': sortKey,
          'cursor': currentCursor != '' ? currentCursor : null
        },
      );
      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      var node = result.data?['node'];

      // printLog('fetchProductsByCategory with new node $node');

      if (node != null) {
        var productResp = node['products'];
        var pageInfo = productResp['pageInfo'];
        var hasNextPage = pageInfo['hasNextPage'];
        var edges = productResp['edges'];

        //printLog('fetchProductsByCategory with products length ${edges.length}');

        if (edges.length != 0) {
          var lastItem = edges.last;
          var cursor = lastItem['cursor'];

          //printLog('fetchProductsByCategory with new cursor $cursor');

          // set next cursor
          shopifyStorage.setShopifyStorage(cursor, categoryId, hasNextPage);
        }

        //printLog(":::: Item Data : ${result.data!['node']['products']['edges']}");

        for (var item in result.data!['node']['products']['edges']) {
          var product = item['node'];
          product['categoryId'] = categoryId;

          /// Hide out of stock.
          if (product['availableForSale'] == false) {
            continue;
          }

          printLog("::: product : ${jsonEncode(product)}");

          list.add(Product.fromJson(product));
        }
      }

      return list;
    } catch (e) {
      printLog('::::fetchProductsByCategory shopify error $e');
      printLog(e.toString());
      rethrow;
    }
  }

  Future<Product> getProduct(id, {lang, cursor}) async {
    /// Private id is id has been encrypted by Shopify, which is get via api
    final isPrivateId = int.tryParse(id) == null;
    if (isPrivateId) {
      return getProductByPrivateId(id);
    }
    printLog('::::request getProduct $id');

    /// Normal id is id the user can see on the admin site, which is not encrypt
    const nRepositories = 50;
    final options = QueryOptions(
      document: gql(ShopifyQuery.getProductById),
      variables: <String, dynamic>{'nRepositories': nRepositories, 'id': id},
    );
    final result = await client.query(options);

    if (result.hasException) {
      printLog(result.exception.toString());
    }
    List? listData = result.data?['products']?['edges'];
    if (listData != null && listData.isNotEmpty) {
      final productData = listData.first['node'];
      return Product.fromJson(productData);
    }
    return Product();
  }

  Future<Product> getProductByPrivateId(id) async {
    printLog('::::request getProductByPrivateId $id');

    const nRepositories = 50;
    final options = QueryOptions(
      document: gql(ShopifyQuery.getProductByPrivateId),
      variables: <String, dynamic>{'nRepositories': nRepositories, 'id': id},
    );
    final result = await client.query(options);

    if (result.hasException) {
      printLog(result.exception.toString());
    }
    return Product.fromJson(result.data!['node']);
  }

  Future<User?> getUserInfo(cookie) async {
    try {
      printLog('::::request getUserInfo');

      const nRepositories = 50;
      final options = QueryOptions(document: gql(ShopifyQuery.getCustomerInfo), fetchPolicy: FetchPolicy.networkOnly, variables: <String, dynamic>{'nRepositories': nRepositories, 'accessToken': cookie});

      final result = await client.query(options);

      printLog('result ${result.data}');

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }

      var user = User.fromShopifyJson(result.data?['customer'] ?? {}, cookie);
      if (user.cookie == null) return null;
      return user;
    } catch (e) {
      printLog('::::getUserInfo shopify error');
      printLog(e.toString());
      rethrow;
    }
  }

  Future<User?> login({username, password}) async {
    try {
      printLog('::::request login');

      var accessToken = await createAccessToken(username: username, password: password);
      var userInfo = await getUserInfo(accessToken);

      printLog('login $userInfo');

      return userInfo;
    } catch (e) {
      printLog('::::login shopify error');
      printLog(e.toString());
      throw Exception('Please check your username or password and try again. If the problem persists, please contact support!');
    }
  }

  Future<User> createUser({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phoneNumber,
    bool isVendor = false,
  }) async {
    try {
      printLog('::::request createUser');

      const nRepositories = 50;
      final options = QueryOptions(document: gql(ShopifyQuery.createCustomer), variables: <String, dynamic>{
        'nRepositories': nRepositories,
        'input': {'firstName': firstName, 'lastName': lastName, 'email': email, 'password': password}
      });

      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }

      final listError = List.from(result.data?['customerCreate']?['userErrors'] ?? []);
      if (listError.isNotEmpty) {
        final message = listError.map((e) => e['message']).join(', ');
        throw Exception('$message!');
      }

      printLog('createUser ${result.data}');

      var userInfo = result.data!['customerCreate']['customer'];
      final token = await createAccessToken(username: email, password: password);
      var user = User.fromShopifyJson(userInfo, token);

      return user;
    } catch (e) {
      printLog('::::createUser shopify error');
      printLog(e.toString());
      rethrow;
    }
  }

  Future<String?> createAccessToken({username, password}) async {
    try {
      printLog('::::request createAccessToken');

      const nRepositories = 50;
      final options = QueryOptions(document: gql(ShopifyQuery.createCustomerToken), variables: <String, dynamic>{
        'nRepositories': nRepositories,
        'input': {'email': username, 'password': password}
      });

      final result = await client.query(options);

      printLog('result ${result.data}');

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }
      var json = result.data!['customerAccessTokenCreate']['customerAccessToken'];
      printLog("json['accessToken'] ${json['accessToken']}");

      return json['accessToken'];
    } catch (e) {
      printLog('::::createAccessToken shopify error');
      printLog(e.toString());
      rethrow;
    }
  }
}
