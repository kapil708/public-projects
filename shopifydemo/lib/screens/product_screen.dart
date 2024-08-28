import 'package:flutter/material.dart';
import 'package:shopifydemo/models/product.dart';
import 'package:shopifydemo/models/shopify_mixin.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with ShopifyMixin {
  List<Product> productList = [];

  @override
  void initState() {
    getData(1);
    super.initState();
  }

  void getData(int page) async {
    String categoryId = "Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzI3MTU2MjM0MjU4MA==";
    List<Product> data = await shopifyService.fetchProductsByCategory(categoryId: categoryId, page: page, limit: 20) ?? [];
    productList.addAll(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Screen"),
        actions: [
          IconButton(
            onPressed: () => getData(2),
            icon: const Icon(Icons.skip_next_sharp),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...productList.map((product) {
              return Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.blue.withOpacity(0.2),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.toJson().toString() ?? ''),
                  ],
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
