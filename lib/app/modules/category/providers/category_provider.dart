import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/data/category_model.dart';

class CategoryProvider extends GetConnect {
  // @override
  // void onInit() {
  //   httpClient.baseUrl = 'YOUR-API-URL';
  // }

  getCategory() async {
    var response = await http.get(Uri.parse("$kEndPoint/doctor_categories"));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      List data = decodedData;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw response.body;
    }
  }
}
