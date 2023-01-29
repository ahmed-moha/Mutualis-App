import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kEndPoint = 'https://mutualis-dj.com/api';
//const kEndPoint = 'http://192.168.10.129:9000/api/';
const kIntroScreen = 'introScreen';
const kUserInfo = 'userInfo';
const kPrimaryColor = Color(0xFF1a60be);
const kSecondaryLightColor = Color(0xffB0DCD2);
const double kPadding = 16;
const String kLogo = 'assets/logos/1.png';
const String kLanguage = 'language';
const String kIsDarkMode = 'false';
const String kfavoriteLectures = 'doctors';
const String kLoading = 'assets/images/loading.json';
const String currentToken = 'currentToken';
const String kFavoriteCourses = 'course';
const String kCourses = 'courses';
const String defaultPhotoUrl =
    "https://d3n8a8pro7vhmx.cloudfront.net/imaginebetter/pages/313/meta_images/original/blank-profile-picture-973460_1280.png";
const kFirebaseUrl="https://fcm.googleapis.com/fcm/send";
const kApi="AAAArW7KxXU:APA91bHqa6aIor6cMrvsmL0yezVGg7VVzHQxO8MO1cHper-eSe-PGLTyzMdF-6IgqcAiangM4nNRuECvADpMGOsq4LDRC3JDD9z6Sv9lwk_c20i8wRz0fm3FIyqW0dDOX8ucsQyxhL5I";

// ignore: constant_identifier_names
const String KIsIntro = 'intro';

// ------------------------- LIGHT THEME CONSTANTS -------------------------
const Color kPrimaryLightColor = Color(0xFF4485FD);

// ------------------------- DARK THEME CONSTANTS -------------------------

const Color kPrimaryDarkColor = Color(0xFF03071e);
const Color kSecondaryDarkColor = Color(0xFF023047);
void erroMessage(String? message) {
  Get.snackbar("uh oh!", message ?? "",
      margin: EdgeInsets.zero,
      borderRadius: 0,
      backgroundColor: Colors.pink,
      colorText: Colors.white);
}
