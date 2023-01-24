import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
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
  bool get isDoctor => user.isDoctor ?? false;
  bool get isAdmin => user.isAdmin ?? false;
  bool get hasData => box.hasData(kUserInfo);
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
  GlobalKey<FormState> addDoctorKey = GlobalKey<FormState>();

  bool isDoctorLoading = false;

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
    await FirebaseAuth.instance.signOut();
    update();
    Get.offAllNamed(Routes.USER);
  }

  registerDoctor(
      {required String name,
      required String email,
      required String password,
      required String catId,
      required String about,
      String? catName}) async {
    if (addDoctorKey.currentState?.validate() ?? false) {
      try {
        isDoctorLoading = true;
        update();
         await UserProvider().registerDoctor(
            name: name,
            email: email,
            password: password,
            catId: catId,
            catName: catName??"",
            about: about,
            );
        Get.snackbar("Success", "Successfuly registered",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.back();
      } catch (e) {
        log(e.toString(), name: "Register Doc error");
        Get.snackbar("oops!", e.toString());
      }
      isDoctorLoading = false;
      update();
    }
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

}
