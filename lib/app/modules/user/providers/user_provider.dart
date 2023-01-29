import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jbuti_app/app/constants.dart';

import '../../../data/user_model.dart';

class UserProvider extends GetConnect {
  final box = GetStorage();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User firebaseUser;

  login({required String username, required String password}) async {
    var response = await http.post(
      Uri.parse("$kEndPoint/login"),
      body: {"email": username, "password": password},
    );
    if (response.statusCode == 200) {
      var data =
          await loginFromFirebase(username: username, password: password);
      // final decodedData = jsonDecode(response.body);
      // if (!decodedData["success"]) throw decodedData["message"];
      // print(
      //   UserModel.fromJson(decodedData["user"]),
      // );
      print("THE DATA IS: $data");
      await saveUser(
        UserModel.fromJson(data),
      );
      return UserModel.fromJson(data);
    } else {
      final decodedData = jsonDecode(response.body);
      throw decodedData;
    }
  }

  register(
      {required String name,
      required String email,
      required String password}) async {
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
      var data = await saveToFirebase(
        name: name,
        email: email,
        password: password,
        userId: decodedData["user"]["id"].toString(),
      );

      print("THE DATA IS: $data");
      await saveUser(
        UserModel.fromJson(data),
      );
      return UserModel.fromJson(data);
    } else {
      final decodedData = jsonDecode(response.body);
      throw decodedData;
    }
  }

  saveToFirebase(
      {required String name,
      required String email,
      required String password,
      required String userId,
      String? desc,
      String? type,
      String? phone,
      bool isDoctor = false}) async {
    try {
      String fcmToken = "";
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseMessaging.instance.getToken().then((value) {
        fcmToken = value ?? "";
      }).catchError((e) => throw e);
      log(fcmToken, name: "THE TOKEN");
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((auth) {
        firebaseUser = auth.user!;
      }).catchError((err) {
        throw err;
      });
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: firebaseUser.uid)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        if (isDoctor == true) {
          log("true");
          String number=phone!.substring(1);
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(firebaseUser.uid)
              .set({
            "id": userId,
            "uid": firebaseUser.uid,
            "email": firebaseUser.email,
            "name": name,
            "photoUrl": defaultPhotoUrl,
            "isDoctor": isDoctor,
            "phone": number,
            "isAdmin": false,
            "type": type ?? "",
            "description": desc ?? "",
            "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
            "state": 1,
            "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
            "fcmToken": fcmToken
          });

          var data = jsonEncode({
            "id": int.parse(userId),
            "uid": firebaseUser.uid,
            "email": firebaseUser.email,
            "name": name,
            "photoUrl": defaultPhotoUrl,
            "isDoctor": isDoctor,
            "isAdmin": false,
            "phone": number,
            "type": type ?? "",
            "description": desc ?? "",
            "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
            "state": 1,
            "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
            "fcmToken": fcmToken
          });
          final decodedData = jsonDecode(data);
          log("SAVED");
          return decodedData;
        } else {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(firebaseUser.uid)
              .set({
            "id": userId,
            "uid": firebaseUser.uid,
            "email": firebaseUser.email,
            "name": name,
            "photoUrl": defaultPhotoUrl,
            "isDoctor": isDoctor,
            "isAdmin": false,
            "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
            "state": 1,
            "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
            "fcmToken": fcmToken
          });

          var data = jsonEncode({
            "id": int.parse(userId),
            "uid": firebaseUser.uid,
            "email": firebaseUser.email,
            "name": name,
            "photoUrl": defaultPhotoUrl,
            "isDoctor": isDoctor,
            "isAdmin": false,
            "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
            "state": 1,
            "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
            "fcmToken": fcmToken
          });
          final decodedData = jsonDecode(data);
          return decodedData;
        }
        // User currentuser = firebaseUser;
        // log(currentuser.toString(), name: "CURRENT USER INFO");
        // log(data.toString(), name: "USER INFO");

        //   FirebaseUser currentuser = firebaseUser;
        //   await preferences.setInt("id", user_id);
        //   await preferences.setString("uid", currentuser.uid);
        //   await preferences.setString("name", userNameEditingController.text);
        //   await preferences.setString("photo", defaultPhotoUrl);
        //   await preferences.setString("email", currentuser.email);
        //   await preferences.setBool("isDoctor", false);
        //   await preferences.setBool("isAdmin", false);
        // } else {
        //   // FirebaseUser currentuser = firebaseUser;
        //   await preferences.setString("uid", documents[0]["uid"]);
        //   await preferences.setString("name", documents[0]["name"]);
        //   await preferences.setString("photo", documents[0]["photoUrl"]);
        //   await preferences.setString("email", documents[0]["email"]);
        //   await preferences.setBool("isDoctor", documents[0]["isDoctor"]);
        //   await preferences.setBool("isAdmin", documents[0]["isAdmin"]);
      } else {
        var data = jsonEncode({
          "id": int.parse(userId),
          "uid": documents[0]["uid"],
          "email": documents[0]["email"],
          "name": documents[0]["name"],
          "photoUrl": defaultPhotoUrl,
          "isDoctor": documents[0]["isDoctor"],
          "isAdmin": documents[0]["isAdmin"],
          "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
          "state": 1,
          "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
          "fcmToken": documents[0]["fcmToken"]
        });
        final decodedData = jsonDecode(data);
        return decodedData;
      }
    } catch (e) {
      rethrow;
    }
  }

  loginFromFirebase({
    required String username,
    required String password,
  }) async {
    var decodedData;
    String fcmToken = "";
    try {
      await FirebaseMessaging.instance.deleteToken();
      await messaging.getToken().then((value) {
        fcmToken = value ?? "";
      }).catchError((e) => throw e);

      await auth
          .signInWithEmailAndPassword(email: username, password: password)
          .then((auth) {
        firebaseUser = auth.user!;
      }).catchError((err) {
        throw err;
      });

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser.uid)
          .update({"fcmToken": fcmToken});

      var data = await FirebaseFirestore.instance
          .collection("Users")
          .doc(firebaseUser.uid)
          .get()
          .then((datasnapshot) async {
        log(datasnapshot.data().toString());
        var data = jsonEncode(datasnapshot.data());
        decodedData = jsonDecode(data);
        return decodedData;
      }).catchError((e) => throw e);

      return decodedData;
    } catch (e) {
      rethrow;
    }
  }

  registerDoctor(
      {required String name,
      required String email,
      required String password,
      required String catId,
      required String catName,
      required String about,
      required String phone}) async {
    print("CALLED");
    var response = await http.post(
      Uri.parse("$kEndPoint/register-doctor"),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'doctor_category_id': catId,
        'about': about
      },
    );
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      if (!decodedData["success"]) throw decodedData;
      await saveToFirebase(
        name: name,
        email: email,
        password: password,
        userId: decodedData["user"]["id"].toString(),
        isDoctor: true,
        desc: about,
        type: catName,
        phone: phone,
      );
      Get.back();
    } else {
      throw response.body;
    }
  }

  saveUser(UserModel user) async {
    await box.remove(kUserInfo);
    box.write(kUserInfo, user.toJson());
    print("SAVED ");
  }
}
