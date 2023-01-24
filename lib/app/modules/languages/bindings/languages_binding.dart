import 'package:get/get.dart';

import '../controllers/languages_controller.dart';

class LanguagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguagesController>(
      () => LanguagesController(),
    );
  }
}
