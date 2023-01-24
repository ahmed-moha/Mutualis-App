import 'package:get/get.dart';
import 'package:jbuti_app/app/modules/category/controllers/category_controller.dart';
import 'package:jbuti_app/app/modules/languages/controllers/languages_controller.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<CategoryController>(CategoryController(), permanent: true);
     Get.put<LanguagesController>(LanguagesController(), permanent: true);
  }
}
