import 'dart:developer';

import "package:http/http.dart" as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/modules/user/views/user_view.dart';

import 'firebase_auth_service.dart';
import 'firebase_exceptions.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthenticationService();
  bool isloading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
                const SizedBox(height: 70),
                const Text(
                  "Mot de passe oublié",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Veuillez entrer votre adresse email ci-dessous pour récupérer votre mot de passe.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Adresse email',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (emValue) {
                    if (emValue == null || emValue.isEmpty) {
                      return "L'email est requis";
                    }

                    String p =
                        "[a-zA-Z0-9+._%-+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
                    RegExp regExp = RegExp(p);

                    if (regExp.hasMatch(emValue)) {
                      // So, the email is valid
                      return null;
                    }

                    return 'Veuillez entrer une adresse email valide';
                  },
                  controller: _emailController,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      color: Color(0xFFb1b2c4),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.05),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF6aa6f8),
                    ),
                    //
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(
                    top: 9.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: isloading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isloading = true;
                            });
                            if (_key.currentState?.validate() ?? false) {
                              checkEmailExists(_emailController.text.trim());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4894e9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Envoyer',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                ),

                /*CustomButton(
                  label: 'RECOVER PASSWORD',
                  color: Colors.black,
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      LoaderX.show(context);
                      final _status = await _authService.resetPassword(
                          email: _emailController.text.trim());
                      if (_status == AuthStatus.successful) {
                        LoaderX.hide();
                        Navigator.pushNamed(context, LoginScreen.id);
                      } else {
                        LoaderX.hide();
                        final error =
                        AuthExceptionHandler.generateErrorMessage(_status);
                        CustomSnackBar.showErrorSnackBar(context,
                            message: error);
                      }
                    }
                  },
                  size: size,
                  textColor: Colors.white,
                  borderSide: BorderSide.none,
                ),*/
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkEmailExists(String email) async {
    try {
        //Dio dio = Dio(ApiConnexion().baseOptions());
    var response = await http.post(Uri.parse("$kEndPoint/check-user-email-exists"), body: {
      "email" : email
    });

    if(response.statusCode==200)
    {
      final status = await _authService.resetPassword(
          email: email
      );

      if (status == AuthStatus.successful) {
        setState(() {
          isloading = false;
        });
        Fluttertoast.showToast(msg: "Un mail vous a été envoyé");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const UserView()
            )
        );
      }else{
        final error =
        AuthExceptionHandler.generateErrorMessage(status);
        Fluttertoast.showToast(msg: error);
      }
    }else{
      setState(() {
        isloading = false;
      });
      Fluttertoast.showToast(msg: "Compte introuvable");
    }
    } catch (e) {
      log(e.toString(), name: "Reset Error");
    }
     setState(() {
          isloading = false;
        });
  }
}
