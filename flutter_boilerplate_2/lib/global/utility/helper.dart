import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_2/controllers/common/loading_controller.dart';
import 'package:flutter_boilerplate_2/global/assets/index.dart' show imageAssets;
import 'package:flutter_boilerplate_2/global/networking/index.dart' show serverConfig;
import 'package:flutter_boilerplate_2/global/route/index.dart';
import 'package:flutter_boilerplate_2/global/theme/index.dart' show appColor, appCss;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

final _storage = GetStorage();
var loadingCtrl = Get.find<LoadingController>();

class Helper {
  //#region Storage
  dynamic getStorage(String name) {
    dynamic info = _storage.read(name) ?? '';
    return info != '' ? json.decode(info) : info;

    //ex : helper.getStorage('authToken');
  }

  Future<dynamic> writeStorage(String key, dynamic value) async {
    dynamic object = value != null ? json.encode(value) : value;
    return await _storage.write(key, object);

    //ex : await helper.writeStorage(session.id, data['id']);
  }

  dynamic removeSpecificKeyStorage(String key) {
    _storage.remove(key);

    //ex : helper.removeSpecificKeyStorage(session.authToken);
  }

  clearStorage() {
    _storage.erase();

    //ex : helper.clearStorage();
  }
  //#endregion

  //#region Snackbar
  snackBar(message, {context, duration}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: appCss.h5.copyWith(color: Colors.white),
      ),
      duration: Duration(
        milliseconds: duration == 'short' ? 1000 : (duration == 'long' ? 4000 : 2000),
      ),
    );

    ScaffoldMessenger.of(context ?? Get.context).clearSnackBars();
    ScaffoldMessenger.of(context ?? Get.context).showSnackBar(snackBar);

    //ex : helper.snackBar('alert message');
  }
  //#endregion

  //#region Is
  bool isNull(val) {
    if (val == null)
      return true;
    else
      return false;

    //ex : helper.isNull(data.val);
  }

  bool isNullOrBlank(dynamic val) {
    if (val is List) {
      if (val == null || val.isEmpty || val.length == 0)
        return true;
      else
        return false;
    } else {
      if (val == null || val == '' || val.toString().isEmpty || val.toString().isBlank!)
        return true;
      else
        return false;
    }

    //ex : helper.isNullOrBlank(data.val);
  }

  bool isEmail(String str) {
    RegExp _email = RegExp(
        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
    return _email.hasMatch(str.toLowerCase());
    // ex : helper.isEmail('abc@gmail.com')
  }

  bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
    //ex : helper.isNumeric('1')
  }

  bool isInt(String str) {
    RegExp _int = RegExp(r'^(?:-?(?:0|[1-9][0-9]*))$');
    return _int.hasMatch(str);
    //ex : helper.isInt('12242342423')
  }

  bool isJson(str) {
    try {
      json.decode(str);
    } catch (e) {
      return false;
    }
    return true;
    //ex : helper.isJson('{"name":"Mary","age":30}')
  }
  //#endregion

  //#region Trim & Replace
  String trim(String str, [String? chars]) {
    RegExp pattern = (chars != null) ? RegExp('^[$chars]+|[$chars]+\$') : RegExp(r'^\s+|\s+$');
    return str.replaceAll(pattern, '');
    //ex : helper.trim(' abv ') ==> abv Remove space from starting of the sentence
  }

  String lTrim(String str, [String? chars]) {
    var pattern = chars != null ? RegExp('^[$chars]+') : RegExp(r'^\s+');
    return str.replaceAll(pattern, '');
    //ex : helper.lTrim(' abv') ==> abv  Remove left side space from starting of the sentence
  }

  String rTrim(String str, [String? chars]) {
    var pattern = chars != null ? RegExp('[$chars]+\$') : RegExp(r'\s+$');
    return str.replaceAll(pattern, '');
    //ex : helper.rTrim('abv ') ==> abv  Remove right space from starting of the sentence
  }

  String whiteList(String str, String chars) {
    return str.replaceAll(RegExp('[^' + chars + ']+'), '');
    //ex : helper.whitelist();
  }

  String blackList(String str, String chars) {
    return str.replaceAll(RegExp('[' + chars + ']+'), '');
    //ex : helper.blackList();
  }
  //#endregion

  //#region As
  String asString(val) {
    if (val != null)
      return val.toString();
    else
      return '';

    //ex : helper.asString(data.val);
  }

  List asList(val) {
    if (val != null)
      return val;
    else
      return [];

    //ex : helper.asList(data.val);
  }

  bool asBool(val) {
    if (val != null && val != '') {
      if (val is bool) {
        return val;
      } else {
        return val == 'true' ? true : false;
      }
    } else
      return false;
    //ex : helper.asBool(data.val);
  }

  int asInt(val) {
    if (val != null && val != '')
      return int.parse(val.toString().split('.')[0]);
    else
      return 0;
    //ex : helper.asInt(data.val);
  }

  double asDouble(val) {
    try {
      if (val != null && val != '')
        return double.parse(val.toString());
      else
        return 0;
    } on Exception catch (e) {
      // TODO
      return 0;
    }
    //ex : helper.asDouble(data.val);
  }

  DateTime? asDate(String date) {
    try {
      if (date != null)
        return DateTime.parse(date);
      else
        return null;
    } on Exception catch (e) {
      // TODO
      return null;
    }

    //ex : helper.toDate('2012-01-26T13:51:50.417-07:00');
  }
  //#endregion

  //#region Widget
  Widget imageNetwork({
    required String url,
    double? height,
    double? width,
    BoxFit? fit,
    Widget? placeholder,
    String? errorImageAsset,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Image.asset(
        errorImageAsset ?? imageAssets.noImageBanner,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
  //#endregion

  //#region Dialog & Alert
  dialogMessage(String message, {String title = "App Name", VoidCallback? onConfirm, VoidCallback? onCancel}) {
    return Get.defaultDialog(
      title: title,
      middleText: "$message",
      onConfirm: onConfirm,
      titleStyle: appCss.h3,
      middleTextStyle: appCss.bodyStyle4,
      confirmTextColor: Colors.white,
      buttonColor: appColor.primaryColor,
      onCancel: onCancel,
    );

    //ex : helper.dialogMessage('dialog message', (){});
  }

  void deleteConfirmation({required context, title, message, onConfirm}) {
    // set up the buttons
    Widget cancelButton = TextButton(
        child: Text("Cancel", style: appCss.bodyStyle5),
        onPressed: () {
          Get.back();
        });
    Widget continueButton = TextButton(child: Text("Continue"), onPressed: onConfirm);
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title ?? "Delete Confirmation", style: appCss.h3),
      content: Text(message ?? "Are you sure you want to delete this?", style: appCss.bodyStyle4),
      actions: [cancelButton, continueButton],
    );
    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });

    // ex: helper.deleteConfirmation(context, (){ print('clicked'); });
  }
  //#endregion

  //#region ForJson
  getFromJson(json, String path, defaultValue) {
    try {
      List pathSplitter = path.split(".");

      /// <String,dynamic> || String
      var returnValue;

      json.forEach((key, value) {
        var currentPatten = pathSplitter[0];
        int index = 0;

        if (currentPatten.contains('[') && currentPatten.contains(']')) {
          int index1 = currentPatten.indexOf('[');
          int? index2 = currentPatten.indexOf(']');

          index = int.parse(currentPatten.substring(index1 + 1, index2));
          currentPatten = currentPatten.substring(0, index1);
        }

        if (key == currentPatten) {
          if (pathSplitter.length == 1) {
            returnValue = value;
            return;
          }

          pathSplitter.remove(pathSplitter[0]);

          if (value == null) {
            returnValue = defaultValue;
            return;
          }
          try {
            try {
              value = value.toJson();
            } catch (error) {
              // handle error
            }

            try {
              if (value is List) {
                value = value[index];
              }
            } catch (error) {
              // handle error
            }

            returnValue = getFromJson(value, pathSplitter.join("."), defaultValue);
          } catch (error) {
            returnValue = defaultValue;
          }
          return;
        }
      });

      return returnValue != null ? returnValue : defaultValue;
    } on Exception catch (e) {
      // TODO
      return defaultValue;
    }

    //ex : helper.getFromJson(jobDetailCtrl.jobData, "salary_range", null);
    //ex : helper.getFromJson(jobDetailCtrl.jobData, "salary_range.from", '');
    //ex : helper.getFromJson(jobDetailCtrl.jobData, "salary_range.from.amount_gross", 0);
    //ex : helper.getFromJson(jobDetailCtrl.jobData, "salary_range[0].from.amount_gross", 'null');
    //ex : helper.getFromJson(jobDetailCtrl.jobData, "salary_range[0].from[1].amount_gross", null);
  }

  dynamic filter(dynamic items, dynamic key, value) {
    return items.where((u) => (u['$key'].toString() != null ? u['$key'].toString().toLowerCase().contains(value.toLowerCase()) : false)).toList();
    //ex : helper.filter(items, 'title', 'ab')
  }
  //#endregion

  //#region Loading
  void showLoading() {
    return loadingCtrl.showLoading();

    //ex : helper.showLoading();
  }

  void hideLoading() {
    return loadingCtrl.hideLoading();

    //ex : helper.hideLoading();
  }
  //#endregion

  getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];

    //ex : helper.getRandomColor();
  }

  getDateString(DateTime date, String? patten) {
    return DateFormat(patten ?? 'dd-MM-yyyy').format(date);

    //ex : helper.getDateString(DateTime.now(), 'dd-MMM-yyyy');
  }

  String getImagePath(dynamic url) {
    if (url != null && url is String) {
      if (url.contains('http') || url.contains('https'))
        return url;
      else {
        return serverConfig.baseUrl + url;
      }
    } else
      return '';

    //ex : helper.getImagePath('https://images.pexels.com/photos/1591447/pexels-photo-1591447.jpeg');
    //ex : helper.getImagePath('photos/1591447/pexels-photo-1591447.jpeg');
  }

  Color getColorFromHexCode(String color) {
    try {
      if (color != null) {
        color = color.replaceAll('#', '');
        String valueString = '0xFF' + color;
        int value = int.parse(valueString);
        return Color(value);
      } else
        return Color(0xFFDBEED3);
    } on Exception catch (e) {
      return Color(0xFFDBEED3);
    }

    //ex : helper.getColorFromHexCode('#TGDU78');
  }

  String currency(val) {
    //var numFormat = NumberFormat.currency(locale: 'hi_IN', symbol: '₹'); //india
    //var numFormat = NumberFormat.currency(locale: 'en_US', symbol: '$'); //us
    var numFormat = NumberFormat.currency(locale: 'de_DE', symbol: '€'); //germany
    return numFormat.format(val);

    //ex : helper.currency(1200);
  }

  checkApiValidationError(data) {
    print(data);
    dynamic error = data['errors'];
    if (!isNullOrBlank(error)) {
      List keys = error.keys.toList();
      if (keys != null && keys.length > 0) {
        var msg = '';
        for (int i = 0; i < keys.length; i++) {
          String key = keys[i].toString();
          print('key : $key');
          if (i > 0) msg += '\n';
          msg += error[key][0].toString();
        }
        snackBar(msg, duration: 'long');
      } else
        snackBar(data['message'], duration: 'long');
    } else
      snackBar(data['message'], duration: 'long');
  }

  apiExceptionMethod(controllerName, e) {
    hideLoading();
    snackBar('something went wrong. Try again after some time');
    print("Exception : on $controllerName");
    print(e.toString());
  }

  Future<bool> isNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity(); //Check For Wifi or Mobile data is ON/OFF
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      final result = await InternetAddress.lookup('google.com'); //Check For Internet Connection
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
        return true;
      else
        return false;
    }
  }

  goToNoInternetScreen() {
    String currentRoute = Get.currentRoute;
    if (currentRoute != routeName.noInternet) {
      Get.toNamed(routeName.noInternet);
    }
  }
}
