import 'dart:ui';

import 'package:bloc_with_services_boilerplate/core/assets/image_assets.dart';

enum Language {
  english(Locale('en', 'US'), ImageAssets.english, 'English'),
  indonesia(Locale('hi', 'IN'), ImageAssets.hindi, 'हिंदी');

  const Language(this.value, this.image, this.text);

  final Locale value;
  final String image;
  final String text;
}
