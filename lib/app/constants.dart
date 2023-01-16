import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kEndPoint = 'https://4127a1d62c85.ngrok.io/api';
//const kEndPoint = 'http://192.168.10.129:9000/api/';
const kIntroScreen = 'introScreen';
const kUserInfo = 'userInfo';
const kPrimaryColor = Color(0xff684DFA);
const kSecondaryLightColor = Color(0xffB0DCD2);
const double kPadding=16;
const String kLogo = 'assets/logos/1.png';
const String kLanguage = 'language';
const String kIsDarkMode = 'false';
const String kfavoriteLectures = 'doctors';
const String kLoading = 'assets/images/loading.json';
const String currentToken = 'currentToken';
const String kFavoriteCourses = 'course';
const String kCourses = 'courses';

// ignore: constant_identifier_names
const String KIsIntro = 'intro';

// ------------------------- LIGHT THEME CONSTANTS -------------------------
const Color kPrimaryLightColor = Color(0xFF4485FD);

// ------------------------- DARK THEME CONSTANTS -------------------------

const Color kPrimaryDarkColor = Color(0xFF03071e);
const Color kSecondaryDarkColor = Color(0xFF023047);
void erroMessage( String? message) {
  Get.snackbar(
     "uh oh!",
    message ?? "",
    margin: EdgeInsets.zero,
    borderRadius: 0,
    backgroundColor: Colors.pink,
    colorText: Colors.white
  );
}
