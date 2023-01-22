import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/data/ambulance_model.dart';

class AmbulancesProvider extends GetConnect {
  // @override
  // void onInit() {
  //   httpClient.baseUrl = 'YOUR-API-URL';
  // }

  getAmbulances() async {
    var response = await http.post(Uri.parse("$kEndPoint/ambulances"));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      List data = decodedData["data"];
      return data.map((e) => AmbulanceModel.fromJson(e)).toList();
    } else {
      throw response.body; 
    }
  }
}
