import 'package:get/get.dart';

import '../controllers/ambulances_controller.dart';

class AmbulancesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AmbulancesController>(
      () => AmbulancesController(),
    );
  }
}
