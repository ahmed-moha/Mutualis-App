import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jbuti_app/app/extensions.dart';

class HomeController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDarkMode = false;
  updateDarkMode(bool dark) {
    isDarkMode = dark;
    update();

    Get.switchTheme(Get.context!);
  }
  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  openDrawer() {
    if (scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      scaffoldKey.currentState!.closeEndDrawer();
    } else {
      scaffoldKey.currentState?.openDrawer();
    }
  }
}
