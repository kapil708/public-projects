import 'dart:developer';
import 'package:shopifydemo/models/user_address.dart';

void printLog(val) {
  log(val);
}

class User {
  String? id;
  bool? loggedIn;
  String? name;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? nicename;
  String? userUrl;
  String? picture;
  String? cookie;
  String? jwtToken;
  Shipping? shipping;
  Billing? billing;
  bool isVender = false;
  bool isDeliveryBoy = false;
  bool? isSocial = false;
  bool? isDriverAvailable;
  bool isManager = false;

  User();

  String get fullName => name ?? [firstName ?? '', lastName ?? ''].join(' ').trim();

  ///FluxListing
  String? role;

  User.fromJson(Map<String, dynamic> json) {
    try {
      isSocial = json['isSocial'] ?? false;
      loggedIn = json['loggedIn'];
      id = json['id'].toString();
      cookie = json['cookie'];
      username = json['username'];
      nicename = json['nicename'];
      firstName = json['firstName'];
      lastName = json['lastName'];
      name = json['displayname'] ?? json['displayName'] ?? '${firstName ?? ''}${(lastName?.isEmpty ?? true) ? '' : ' $lastName'}';

      email = json['email'] ?? id;
      userUrl = json['avatar'];
    } catch (e) {
      printLog(e.toString());
    }
  }

  User.fromShopifyJson(Map<String, dynamic> json, token) {
    try {
      printLog('fromShopifyJson user $json');

      loggedIn = true;
      id = json['id'].toString();
      username = '';
      cookie = token;
      firstName = json['firstName'];
      lastName = json['lastName'];
      name = json['displayName'] ?? json['displayname'] ?? _getDisplayName;
      email = json['email'];
      picture = '';
    } catch (e) {
      printLog(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'loggedIn': loggedIn, 'name': name, 'firstName': firstName, 'lastName': lastName, 'username': username, 'email': email, 'picture': picture, 'cookie': cookie, 'nicename': nicename, 'url': userUrl, 'isSocial': isSocial, 'isVender': isVender, 'billing': billing?.toJson(), 'jwtToken': jwtToken, 'role': role};
  }

  User.fromLocalJson(Map<String, dynamic> json) {
    try {
      loggedIn = json['loggedIn'];
      id = json['id'].toString();
      name = json['name'];
      cookie = json['cookie'];
      username = json['username'];
      firstName = json['firstName'];
      lastName = json['lastName'];
      email = json['email'];
      picture = json['picture'];
      nicename = json['nicename'];
      userUrl = json['url'];
      isSocial = json['isSocial'];
      isVender = json['isVender'];
      jwtToken = json['jwtToken'];
      if (json['billing'] != null) {
        billing = Billing.fromJson(json['billing']);
      }
      role = json['role'];
    } catch (e) {
      printLog(e.toString());
    }
  }

  // from Create User
  User.fromAuthUser(Map<String, dynamic> json, String? cookieVal) {
    try {
      cookie = cookieVal;
      id = json['id'].toString();
      name = json['displayname'];
      username = json['username'];
      firstName = json['firstname'];
      lastName = json['lastname'];
      email = json['email'];
      picture = json['avatar'];
      nicename = json['nicename'];
      userUrl = json['url'];
      loggedIn = true;
      var roles = json['role'] as List;

      isVender = false;
      if (roles.isNotEmpty) {
        role = roles.first;
        if (roles.contains('seller') || roles.contains('wcfm_vendor') || roles.contains('administrator') || roles.contains('owner')) {
          isVender = true;
        }
        if (roles.contains('wcfm_delivery_boy') || roles.contains('driver')) {
          isDeliveryBoy = true;
        }
        isManager = roles.contains('shop_manager') || roles.contains('administrator');
      } else {
        isVender = (json['capabilities']['wcfm_vendor'] as bool?) ?? false;
      }
      if (json['dokan_enable_selling'] != null && json['dokan_enable_selling'].trim().isNotEmpty) {
        isVender = json['dokan_enable_selling'] == 'yes';
      }

      if (json['shipping'] != null) {
        shipping = Shipping.fromJson(json['shipping']);
      }
      if (json['billing'] != null) {
        billing = Billing.fromJson(json['billing']);
      }
      if (json['is_driver_available'] != null) {
        isDriverAvailable = json['is_driver_available'] == 'on';
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  User.fromWordpressUser(Map<String, dynamic> json, String? cookieVal) {
    try {
      cookie = cookieVal;
      id = json['id'].toString();
      name = json['displayname'];
      username = json['username'];
      firstName = json['firstname'];
      lastName = json['lastname'];
      email = json['email'];
      picture = json['avatar'];
      nicename = json['nicename'];
      userUrl = json['url'];
      loggedIn = true;
      var roles = json['role'] as List;

      if (roles.isNotEmpty) {
        role = roles.first;
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  String get _getDisplayName => '${firstName ?? ''}${(lastName?.isEmpty ?? true) ? '' : ' $lastName'}';

  @override
  String toString() => 'User { username: $id $name $email}';
}
