import 'dart:developer';

import 'package:get/get.dart';
import 'package:jbuti_app/app/data/ambulance_model.dart';
import 'package:jbuti_app/app/modules/ambulances/providers/ambulances_provider.dart';

class AmbulancesController extends GetxController {
  List<AmbulanceModel> ambulances = [];
  bool isLoadingAmbulance = false;
  getAmbulances() async {
    try {
      isLoadingAmbulance = true;
      update();
      ambulances = await AmbulancesProvider().getAmbulances();
      update();
    } catch (e) {
      log(e.toString(), name: "Get Ambulances");
    }
    isLoadingAmbulance = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getAmbulances();
  }
}
