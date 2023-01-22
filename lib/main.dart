import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/constants.dart';
import 'app/routes/app_pages.dart';
import 'app/theme.dart';
import 'generated/locales.g.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();
  await box.writeIfNull(kLanguage, const Locale('en', 'US').toLanguageTag());
  await box.writeIfNull(kIsDarkMode, false);
  await box.writeIfNull(KIsIntro, false);
  final isDarkMode = box.read(kIsDarkMode) as bool;
  final strLocale = box.read(kLanguage) as String;
  bool isIntro = box.read(KIsIntro);
  bool isLogin = box.hasData(kUserInfo);
  var data=await box.read(kUserInfo);
  print(kUserInfo);
  print(isLogin);
  runApp(
    GetMaterialApp(
      title: "Mutualis App",
      debugShowCheckedModeBanner: false,
      initialRoute: isLogin ? AppPages.INITIAL : Routes.USER,
      getPages: AppPages.routes,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: Apptheme.light,
      darkTheme: Apptheme.dark,
      translationsKeys: AppTranslation.translations,
      locale: Locale(strLocale.substring(0, 2), strLocale.substring(3, 5)),
      //initialRoute: isIntro == true ? AppPages.INITIAL : Routes.INTRO,
      textDirection: TextDirection.ltr,
    ),
  );
}
