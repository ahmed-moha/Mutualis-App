import 'dart:async' show Future;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'package:image_picker/image_picker.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../../../../../components/user_state_methods.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "Mon Compte",
          style: TextStyle(letterSpacing: 1.25, fontSize: 20,color: Theme.of(context).hoverColor),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).hoverColor
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.logout),
            onPressed: () => UserStateMethods().logoutuser(),
          )
        ],
        centerTitle: true,
      ),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  // SharedPreferences preferences;
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController specialiteTextEditingController =
      TextEditingController();
  TextEditingController aboutTextEditingController = TextEditingController();

  String id = "";
  String name = "";
  String email = "";
  String photoUrl = "";
  File? imageFileAvatar;
  bool isLoading = false;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  bool _status = true;
  bool isInitialLoading = false;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataFromLocal();
  }

  readDataFromLocal() async {
    isInitialLoading = true;
    // preferences = await SharedPreferences.getInstance();
    final user = Get.find<UserController>().user;
    id = user.uid ?? "";
    name = user.name ?? "";
    photoUrl = user.photoUrl ?? "";
    email = user.email ?? "";

    nameTextEditingController = TextEditingController(text: name);
    emailTextEditingController = TextEditingController(text: email);
    phoneTextEditingController = TextEditingController(text: "");
    aboutTextEditingController = TextEditingController(text: "");
    specialiteTextEditingController = TextEditingController(text: "");
    isInitialLoading = false;
    setState(() {});
    // return Future.delayed(Duration(seconds: 2), () => "Hello");
    // return photoUrl;
  }

  Future getImage() async {
    //final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFileAvatar = File(pickedFile.path);
        isLoading = true;
      }
    });

    if (pickedFile != null) {
      // upload image to firebase storage
      uploadImageToFirestoreAndStorage();
    }
  }

  Future uploadImageToFirestoreAndStorage() async {
    final user = Get.find<UserController>().user;
    String mFileName = id;
    Reference storageReference =
        FirebaseStorage.instance.ref().child(mFileName);
    UploadTask storageUploadTask = storageReference.putFile(imageFileAvatar!);
    TaskSnapshot storageTaskSnapshot;
    storageUploadTask.whenComplete(() => null).then((value) {
      if (value.storage == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
          photoUrl = newImageDownloadUrl;
          FirebaseFirestore.instance
              .collection("Users")
              .doc(id)
              .update({"photoUrl": photoUrl, "name": name}).then((data) async {
            user.photoUrl != photoUrl;

            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Mise à jour réussie.");
          });
        }, onError: (errorMsg) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Une erreur s'est produite ! Réessayer");
        });
      }
    }, onError: (errorMsg) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: errorMsg.toString());
    });
  }

  void updateData() {
    final user = Get.find<UserController>().user;
    nameFocusNode.unfocus();
    emailFocusNode.unfocus();
    setState(() {
      isLoading = false;
    });

    FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .update({"name": name}).then((data) async {
      user.photoUrl = photoUrl;
      user.name = name;
      // await preferences.setString("photo", photoUrl);
      // await preferences.setString("name", name);

      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Mise à jour réussie.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return isInitialLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  children: <Widget>[
                    //Profile Image - Avatar
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            (imageFileAvatar == null)
                                // ? (photoUrl != "")
                                ? Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Material(
                                            // display already existing image
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(125.0)),
                                            clipBehavior: Clip.hardEdge,
                                            // display already existing image
                                            child: Icon(
                                              Icons.account_circle,
                                              size: 90.0,
                                              color: Colors.grey,
                                            )),
                                      ],
                                    ),
                                  )
                                // : Icon(
                                //     Icons.account_circle,
                                //     size: 90.0,
                                //     color: Colors.grey,
                                //   )
                                : Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Material(
                                            // display new updated image
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(125.0)),
                                            clipBehavior: Clip.hardEdge,
                                            // display new updated image
                                            child: Image.file(
                                              imageFileAvatar!,
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            )),
                                      ],
                                    ),
                                  ),
                            GestureDetector(
                              onTap: getImage,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 150.0, right: 120.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 25.0,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),

                    Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(),
                      ),
                    ]),

                    Container(
                      color: const Color(0xFFFFFFFF),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Informations Personnelles',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status ? _getEditIcon() : Container(),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Nom',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          hintText: "Taper votre nom",
                                        ),
                                        controller: nameTextEditingController,
                                        enabled: !_status,
                                        autofocus: !_status,
                                        onChanged: (value) {
                                          name = value;
                                        },
                                        focusNode: nameFocusNode,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Adresse Email',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                            hintText: "Taper votre email"),
                                        enabled: !_status,
                                        controller: emailTextEditingController,
                                        focusNode: emailFocusNode,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Numéro de téléphone',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Taper votre téléphone"),
                                        enabled: !_status,
                                        controller: phoneTextEditingController,
                                        focusNode: emailFocusNode,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Spécialité',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Taper votre spécialité"),
                                        enabled: !_status,
                                        controller:
                                            specialiteTextEditingController,
                                        focusNode: emailFocusNode,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'A propos de vous',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                            hintText:
                                                "Taper votre description"),
                                        enabled: !_status,
                                        controller: aboutTextEditingController,
                                        focusNode: emailFocusNode,
                                      ),
                                    ),
                                  ],
                                )),
                            !_status ? _getActionButtons() : Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  updateData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text("Mettre à jour",style: TextStyle(color: Colors.white),),
              )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                ),
                onPressed: () {
                  /*setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });*/

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PasswordSettings()));
                  // logoutuser();
                },
                child: const Text(
                  "Changer mot de passe",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
