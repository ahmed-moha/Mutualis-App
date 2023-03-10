import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/modules/user/views/forgot/reset_password.dart';
import 'package:jbuti_app/app/modules/user/views/register_view.dart';
import 'package:jbuti_app/generated/locales.g.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  const UserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (cont) {
      return ModalProgressHUD(
        inAsyncCall: cont.isLoginLoading,
        progressIndicator: const SizedBox(),
        child: Scaffold(
            // appBar: AppBar(
            //   title: const Text('UserView'),
            //   centerTitle: true,
            // ),
            body: SingleChildScrollView(
          child: Form(
            key: cont.loginKey,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.75,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1.0, 0.0),
                      end: Alignment(1.0, 0.0),
                      colors: [Color(0xFF6aa6f8), Color(0xFF1a60be)],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Image.asset(
                            "assets/images/logo.png",
                            color: Colors.white,
                            height: 100,
                          ),
                      Container(
                        child: const Text(
                          'Connexion',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                      /*Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 15.0,
                                        left: 40.0,
                                        right: 40.0,
                                      ),
                                      child: Text(
                                        'Bienvenue sur Mutualis App',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ),*/
                      Container(
                        transform: Matrix4.translationValues(0.0, 50.0, 0.0),
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        width: double.infinity,
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          color: Theme.of(context).cardColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 50.0,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(20.0),
                              child: TextFormField(
                               // keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Please enter valid email";
                                  }
                                  return null;
                                },
                                controller: cont.email,
                                textCapitalization: TextCapitalization.none,
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.email.tr,
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFb1b2c4),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.05),
                                  prefixIcon: const Icon(
                                    IconlyLight.message,
                                    color: Color(0xFF6aa6f8),
                                  ),
                                  //
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                              ),
                              child: TextFormField(
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Please enter  Password";
                                  }
                                  return null;
                                },
                                controller: cont.password,
                                keyboardType: TextInputType.visiblePassword,
                                //controller: passwordTextEditingController,
                                obscureText: cont.isVisiblePassword,
                                decoration: InputDecoration(
                                    hintText: LocaleKeys.password.tr,
                                    hintStyle: const TextStyle(
                                      color: Color(0xFFb1b2c4),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    filled: true,
                                    fillColor: Colors.black.withOpacity(0.05),
                                    prefixIcon: const Icon(
                                      IconlyLight.lock,
                                      color: Color(0xFF6aa6f8),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: !cont.isVisiblePassword
                                          ? const Icon(
                                              CupertinoIcons.eye,
                                              size: 20,
                                              color: kPrimaryColor,
                                            )
                                          : const Icon(
                                              CupertinoIcons.eye_slash,
                                              size: 20,
                                              color: kPrimaryColor,
                                            ),
                                      onPressed: () => cont.updateVisiblity(
                                          !cont.isVisiblePassword),
                                    )
                                    //
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 55,
                  margin: const EdgeInsets.only(
                    top: 90.0,
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4894e9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                    onPressed: () => cont.login(),
                    child: Align(
                      alignment: Alignment.center,
                      child: cont.isLoginLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          :  Text(
                              LocaleKeys.login.tr,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: RichText(
                        text: TextSpan(
                            text: LocaleKeys.dont_have_an_account.tr,
                            style:
                                TextStyle(color: Theme.of(context).hoverColor),
                            children:  [
                              TextSpan(
                                  text: " ${LocaleKeys.create_one.tr}",
                                  style: const TextStyle(color: kPrimaryColor))
                            ]),
                      ),
                    ),
                    onTap: () => Get.to(() => const RegisterView()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 0.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: RichText(
                        text:  TextSpan(
                          text: "${LocaleKeys.forgot_password.tr}?",
                          style: const TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    onTap: () =>Get.to(()=>ResetPasswordScreen()),
                  ),
                ),
              ],
            ),
          ),
        )),
      );
    });
  }
}
