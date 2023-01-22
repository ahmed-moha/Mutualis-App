import 'dart:developer';

import 'package:get/get.dart';
import 'package:jbuti_app/app/modules/category/providers/category_provider.dart';

import '../../../data/category_model.dart';

class CategoryController extends GetxController {
  List<CategoryModel> categories = [];
  bool isLoadingCategory = false;
  getCategory() async {
    try {
      isLoadingCategory = true;
      update();
      categories = await CategoryProvider().getCategory();
      update();
    } catch (e) {
      log(e.toString());
    }
    isLoadingCategory = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getCategory();
  }
}
