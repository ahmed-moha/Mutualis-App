import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';
import '../../../constants.dart';
import 'ambulances_enquire_list.dart';

class RequestAmbulancePage extends StatefulWidget {
  const RequestAmbulancePage({
    Key? key,
    required this.ambulance_id,
    required this.ambulance_name,
    required this.ambulance_phone,
    required this.ambulance_adresse,
  }) : super(key: key);
  final String ambulance_id;
  final String ambulance_name;
  final String ambulance_phone;
  final String ambulance_adresse;
  @override
  RequestAmbulancePageState createState() => RequestAmbulancePageState();
}

class RequestAmbulancePageState extends State<RequestAmbulancePage>
    with SingleTickerProviderStateMixin {
  String ambulance_id = "";
  String ambulance_name = "";
  final FocusNode myFocusNode = FocusNode();
  String name = '';
  int patient_id = 0;
  DateTime currentDate = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isloading1 = false;
  bool isloading2 = false;

  TextEditingController dateEditingController = TextEditingController();
  TextEditingController hourEditingController = TextEditingController();

  // SharedPreferences preferences;

  String? _hour, _minute, _time;

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    selectedTime = picked!;
    selectedTime.hour < 10
        ? _hour = "0${selectedTime.hour}"
        : selectedTime.hour.toString();
    selectedTime.minute < 10
        ? _minute = "0${selectedTime.minute}"
        : selectedTime.minute.toString();

    hourEditingController.text = "${_hour!}:${_minute!}";
  }

  // _loadUser() async {
  //   preferences = await SharedPreferences.getInstance();

  //   if (preferences.getInt('id') != null)
  //   {
  //     setState(() {
  //       patient_id = preferences.getInt('id');
  //     });
  //   }
  // }

  @override
  void initState() {
    ambulance_id = widget.ambulance_id;
    ambulance_name = widget.ambulance_name;
    // _loadUser();
    super.initState();
  }

  _appbar() {
    return AppBar(
      elevation: 0,
      title: const Text("Formulaire ambulance"),
      backgroundColor: kPrimaryColor,
      leading: Builder(
        builder: (context) => // Ensure Scaffold is in context
            const BackButton(color: Colors.white),
      ),
    );
  }

  void _requestAmbulance() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          isloading2 = true;
        });
        //Dio dio = Dio(ApiConnexion().baseOptions());

        String date = dateEditingController.text;
        String hour = hourEditingController.text;
        final user = Get.find<UserController>().user;
        var body = {
          'location': date,
          'time': hour,
          'patient_id': user.id.toString(),
          'ambulance_id': ambulance_id,
        };
        log(body.toString(), name: "VALUES");
        var response = await http
            .post(Uri.parse('$kEndPoint/enquire-ambulance'), body: body);
        //widget.onChangedStep(1)
        if (response.statusCode == 200) {
          final decodedData = jsonDecode(response.body);
          setState(() {
            isloading2 = false;
          });

          if (decodedData["success"] == true) {
            print(decodedData);
            AlertDialog dialog = AlertDialog(
              title: const Text('Info'),
              content: Text(decodedData["message"].toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAmbulancesPage(),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return dialog;
              },
            );
            /*SharedPreferences localStorage = await SharedPreferences.getInstance();
          await localStorage.setString('user', jsonEncode(response.data['user']));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()));*/
          } else {
            print(response);
            AlertDialog dialog = AlertDialog(
              title: const Text('Info'),
              content: Text(decodedData["message"].toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return dialog;
              },
            );
          }
        } else {
          throw response.body;
        }
      }
    } catch (e) {
      log(e.toString(), name: "Request Ambulance error");
      Get.snackbar("Oops", e.toString());
    }
    setState(() {
      isloading2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Image.asset(
                'assets/images/ambulance.jpg',
                fit: BoxFit.cover,
                height: 230.0,
                width: double.infinity,
              ),
              Container(
                color: const Color(0xffFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 0.0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    'Demande de l\'ambulance',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${widget.ambulance_name} | ${widget.ambulance_phone}",
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
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
                                            "Lieu d'intervention",
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
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Veuillez préciser l'adresse";
                                            }

                                            return null;
                                          },
                                          // validator: (val) {
                                          //   return val.isEmpty
                                          //       ?
                                          //       : null;
                                          // },
                                          controller: dateEditingController,
                                          decoration: InputDecoration(
                                            hintText: 'Adresse',
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFb1b2c4),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            filled: true,
                                            fillColor:
                                                Colors.black.withOpacity(0.05),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 20.0,
                                              horizontal: 25.0,
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.location_pin,
                                              color: Color(0xFF6aa6f8),
                                            ),
                                          ),
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
                                            'Description de la scène',
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
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Veuillez décrire la scène";
                                            }

                                            return null;
                                          },
                                          controller: hourEditingController,
                                          decoration: InputDecoration(
                                            hintText: "Que s'est il passé ?",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFb1b2c4),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            filled: true,
                                            fillColor:
                                                Colors.black.withOpacity(0.05),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 20.0,
                                              horizontal: 25.0,
                                            ),
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0,
                                    left: 20.0,
                                    right: 20.0,
                                    bottom: 20.0),
                                child: isloading2
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: () async {
                                          _requestAmbulance();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(15),
                                          backgroundColor:
                                              const Color(0xFF4894e9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
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
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}
