import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'constants.dart';


extension GetEx on GetInterface {
  Future<void> switchTheme(BuildContext context) async {
    final box = GetStorage();

    changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);

    Theme.of(context).brightness == Brightness.light;
    await box.write(kIsDarkMode, !Get.isDarkMode);
  }

  Future<void> changeLanguage(Locale locale) async {
    final box = GetStorage();
    await box.write(kLanguage, locale.toLanguageTag());
    Get.updateLocale(locale);
  }
}
