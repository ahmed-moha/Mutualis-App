import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jbuti_app/app/data/user_model.dart';
import 'package:jbuti_app/app/modules/user/providers/user_provider.dart';

import '../../../constants.dart';
import '../../../routes/app_pages.dart';

class UserController extends GetxController {
  UserController() {
    getUser();
  }
  UserModel user = UserModel();
  final box = GetStorage();

  // LOGIN PART
  bool isLoginLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // LOGIN PART
  // REGISTER PART
  bool isRegisterLoading = false;
  TextEditingController rEmail = TextEditingController();
  TextEditingController rPassword = TextEditingController();
  TextEditingController rName = TextEditingController();

  // REGISTER PART
  bool isVisiblePassword = false;
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
    GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  updateVisiblity(bool isVisible) {
    isVisiblePassword = isVisible;
    update();
  }

  login() async {
    if (loginKey.currentState?.validate() ?? false) {
      try {
        if (password.text.length >= 8) {
          isLoginLoading = true;
          update();
          Get.focusScope?.unfocus();
          user = await UserProvider()
              .login(username: email.text, password: password.text);
          update();
          Get.offNamed(Routes.HOME);
        } else {
          Get.snackbar("sorry", "Password length must greather than 8 digits",
              backgroundColor: kPrimaryColor, colorText: Colors.white);
        }
      } catch (e) {
        log(e.toString(), name: "Login Error");
        Get.snackbar(
          "oops!",
          e.toString(),
        );
      }
      isLoginLoading = false;
      update();
    }
  }

  register() async {
    if (registerKey.currentState?.validate() ?? false) {
      try {
        if (rPassword.text.length >= 8) {
          isRegisterLoading = true;
          update();
          user = await UserProvider().register(
              name: rName.text, email: rEmail.text, password: rPassword.text);
          update();
          Get.offNamed(Routes.HOME);
        } else {
          Get.snackbar("sorry", "Password length must greather than 8 digits",
              backgroundColor: kPrimaryColor, colorText: Colors.white);
        }
      } catch (e) {
        log(e.toString(), name: "Register Error");
        Get.snackbar("oops!", e.toString());
      }
      isRegisterLoading = false;
      update();
    }
  }

  getUser() {
    try {
      if (box.hasData(kUserInfo)) {
        print("HAS DATA: ${true}");
        final json = box.read(kUserInfo);
        log("The user is: $kUserInfo");
        if (json != null) {
          user = UserModel.fromJson(json);
          update();
        }
      } else {
        print("NO DATA");
      }
    } catch (e) {
      log(e.toString(), name: "Get User Error");
    }
  }

  logOut() async {
    await box.write(kUserInfo, null);
    await box.remove(kUserInfo);
    update();
    Get.offAllNamed(Routes.USER);
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

}
