import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
    final scaffoldKey = GlobalKey<ScaffoldState>();
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
