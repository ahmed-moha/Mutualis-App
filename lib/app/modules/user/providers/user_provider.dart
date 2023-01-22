import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jbuti_app/app/constants.dart';

import '../../../data/user_model.dart';

class UserProvider extends GetConnect {
  final box = GetStorage();
  login({required String username, required String password}) async {
    var response = await http.post(
      Uri.parse("$kEndPoint/login"),
      body: {"email": username, "password": password},
    );
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      if (!decodedData["success"]) throw decodedData["message"];
      print(
        UserModel.fromJson(decodedData["user"]),
      );
      await saveUser(
        UserModel.fromJson(decodedData["user"]),
      );
      return UserModel.fromJson(decodedData["user"]);
    } else {
      final decodedData = jsonDecode(response.body);
      throw decodedData;
    }
  }

  register(
      {required String name, required String email, required password}) async {
    var response = await http.post(
      Uri.parse("$kEndPoint/register"),
      body: {"name": name, "email": email, "password": password},
    );
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      if (!decodedData["success"]) throw decodedData["errors"][0];
      print(
        UserModel.fromJson(decodedData["user"]),
      );
      await saveUser(
        UserModel.fromJson(decodedData["user"]),
      );
      return UserModel.fromJson(decodedData["user"]);
    } else {
      final decodedData = jsonDecode(response.body);
      throw decodedData;
    }
  }

  saveUser(UserModel user) async {
    await box.remove(kUserInfo);
    box.write(kUserInfo, user.toJson());
    print("SAVED ");
  }
}
