import 'package:dropdown_search/dropdown_search.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jbuti_app/app/modules/category/controllers/category_controller.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../../../constants.dart';

class AddDoctorPage extends StatefulWidget {
  @override
  AddDoctorPageState createState() => AddDoctorPageState();
}

class AddDoctorPageState extends State<AddDoctorPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isloading1 = false;
  bool _passwordVisible = false;

  final String defaultPhotoUrl =
      "https://d3n8a8pro7vhmx.cloudfront.net/imaginebetter/pages/313/meta_images/original/blank-profile-picture-973460_1280.png";
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController aboutEditingController = TextEditingController();
  TextEditingController specialiteEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController cpasswordEditingController = TextEditingController();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String fcmToken = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String dropdownValue = 'Pédiatrie';
  //List <String> spinnerItems = [];
  //static List<Categorie> categories = [];
  int categorieId = 0;
  String categorieLabel = "";
  bool loading = true;

  // Future<List<Categorie>> fetchListCategories() async
  // {
  //   final response = await http.get(Uri.parse(ApiConnexion.baseUrl+'/doctor_categories'));
  //   setState(() {
  //     loading = false;
  //   });
  //   if (response.statusCode == 200) {
  //     final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
  //     setState(() {
  //       categories = parsed.map<Categorie>((json) => Categorie.fromMap(json)).toList();
  //     });

  //     return parsed.map<Categorie>((json) => Categorie.fromMap(json)).toList();
  //   } else {
  //     throw Exception('Failed to load Categories');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // fetchListCategories();
    _passwordVisible = false;
    _messaging.getToken().then((value) {
      fcmToken = value ?? "";
    });
  }

  Widget _appbar() {
    return AppBar(
      elevation: 0,
      title: const Text("Ajouter un docteur"),
      backgroundColor: kPrimaryColor,
      leading: Builder(
        builder: (context) => // Ensure Scaffold is in context
            const BackButton(color: Colors.white),
      ),
    );
  }

  // void _registeruserFirebase(int userId) async {
  //   var msg;
  //   if (_formKey.currentState?.validate()??false) {
  //     setState(() {
  //       isloading1 = true;
  //     });
  //     //preferences = await SharedPreferences.getInstance();
  //     User firebaseUser;

  //     await _auth
  //         .createUserWithEmailAndPassword(
  //         email: emailEditingController.text.trim(),
  //         password: passwordEditingController.text.trim())
  //         .then((auth) {
  //       firebaseUser = auth.user;
  //     }).catchError((err) {
  //       setState(() {
  //         isloading1 = false;
  //       });

  //       msg = err.code;
  //     });

  //     if (firebaseUser != null) {
  //       final QuerySnapshot result = await Firestore.instance
  //           .collection("Users")
  //           .where("uid", isEqualTo: firebaseUser.uid)
  //           .getDocuments();

  //       final List<DocumentSnapshot> documents = result.documents;
  //       if (documents.isEmpty) {
  //         Firestore.instance
  //             .collection("Users")
  //             .document(firebaseUser.uid)
  //             .setData({
  //           "id": userId,
  //           "uid": firebaseUser.uid,
  //           "email": firebaseUser.email,
  //           "name": nameEditingController.text,
  //           "description": aboutEditingController.text,
  //           "photoUrl": defaultPhotoUrl,
  //           "isDoctor": true,
  //           "isAdmin": false,
  //           "type": categorieLabel,
  //           "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
  //           "state": 1,
  //           "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
  //           "fcmToken": fcmToken
  //         });
  //       }

  //       setState(() {
  //         isloading1 = false;
  //       });

  //       Route route = MaterialPageRoute(
  //           builder: (c) => AdminHomeScreen(
  //             currentuserid: firebaseUser.uid,
  //           ));
  //       Navigator.pushReplacement(context, route);
  //     } else {
  //       setState(() {
  //         isloading1 = false;
  //       });
  //       msg == 'email-already-in-use'
  //           ? Fluttertoast.showToast(
  //           msg: "Cette adresse email est déjà utilisée ! Essayer un autre")
  //           : Fluttertoast.showToast(
  //           msg: "Une erreur s'est produite. Veuillez réessayer !");
  //     }
  //   }
  // }

  // void _registerUser() async{
  //   if(_formKey.currentState.validate())
  //   {
  //     setState(() {
  //       isloading1 = true;
  //     });
  //     Dio dio = Dio(ApiConnexion().baseOptions());

  //     String name = nameEditingController.text;
  //     String email = emailEditingController.text;
  //     String password = cpasswordEditingController.text;
  //     String about = aboutEditingController.text;
  //     var response = await dio.post('/register-doctor', data: {'name': name, 'email': email, 'password': password,
  //       'doctor_category_id' : categorieId.toString(), 'about' : about});
  //     //widget.onChangedStep(1)
  //     if(response != null) {
  //       setState(()
  //       {
  //         isloading1 = false;
  //       });

  //       if(response.data["success"] == true)
  //       {
  //         _registeruserFirebase(response.data['user']['id']);
  //         /*SharedPreferences localStorage = await SharedPreferences.getInstance();
  //         await localStorage.setString('user', jsonEncode(response.data['user']));
  //         Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => HomePage()));*/
  //       }else{
  //         print(response.data);
  //         AlertDialog d = AlertDialog(
  //           title: const Text('Ajout Docteur'),
  //           content: Text(response.data['message'].toString()),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, 'Annuler'),
  //               child: const Text('Fermer'),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, 'OK'),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );

  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return d;
  //           },
  //         );
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (cont) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text("Ajouter un docteur"),
            backgroundColor: kPrimaryColor,
            leading: Builder(
              builder: (context) => // Ensure Scaffold is in context
                  const BackButton(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
                key: cont.addDoctorKey,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 25, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nom et prénoms",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Veuillez entrer le nom du docteur";
                          }
                          return null;
                        },
                        controller: nameEditingController,
                        decoration:
                            const InputDecoration(hintText: "Nom et prenoms"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Adresse email',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Veuillez préciser l'email";
                            }
                            return null;
                          },
                          controller: emailEditingController,
                          decoration: const InputDecoration(hintText: "Email")),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Spécialité du docteur',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 60,
                        child: GetBuilder<CategoryController>(builder: (cont) {
                          var categories = cont.categories;
                          return DropdownSearch(
                            validator: (v) => v == null ? "requis" : null,
                            //mode: Mode.DIALOG,
                            items: categories,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  hintText: "Spécialité du docteur"),
                            ),
                            enabled: true,
                            //showSearchBox: true,

                            itemAsString: (item) => item.label ?? "",
                            // showClearButton: true,
                            onChanged: (item) {
                              setState(() {
                                categorieId = item?.id ?? 0;
                                categorieLabel = item?.label ?? "";
                              });
                              print("ItemSelec : $item");
                            },
                            //dropdownSearchDecoration: inputDecoration(hintText: "Spécialité du docteur"),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'A propos',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Veuillez décrire le docteur";
                          }
                          return null;
                        },
                        controller: aboutEditingController,
                        decoration: const InputDecoration(
                            hintText: "Description du docteur"),
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Mot de passe',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Veuillez entrer un mot de passe de plus de 6 caractères";
                            }
                            return null;
                          },
                          controller: passwordEditingController,
                          obscureText: !_passwordVisible,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                              hintText: 'Mot de passe',
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
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 25.0,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF6aa6f8),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF6aa6f8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              )
                              //
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Les mots de passe ne sont pas identiques";
                            }
                            return null;
                          },
                          controller: cpasswordEditingController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                              hintText: 'Confirmer le mot de passe',
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
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 25.0,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF6aa6f8),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF6aa6f8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              )
                              //
                              ),
                        ),
                      ),
                      GetBuilder<UserController>(builder: (cont) {
                        return Container(
                          height: 55,
                          margin: const EdgeInsets.only(
                              top: 15.0, left: 15.0, right: 20.0, bottom: 20.0),
                          child: cont.isDoctorLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ElevatedButton(
                                  onPressed: () => cont.registerDoctor(
                                      name: nameEditingController.text,
                                      email: emailEditingController.text,
                                      password: passwordEditingController.text,
                                      catId: categorieId.toString(),
                                      catName: categorieLabel,
                                      about: aboutEditingController.text),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Valider',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                        );
                      }),
                    ],
                  ),
                )),
          ));
    });
  }
}
