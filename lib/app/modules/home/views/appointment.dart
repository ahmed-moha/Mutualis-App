import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jbuti_app/app/config.dart';
import 'package:jbuti_app/app/data/doctor_model.dart';

import 'package:http/http.dart' as http;
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../../../../generated/locales.g.dart';
import '../../../constants.dart';
import '../../../data/Time.dart';
import '../../ambulances/views/appointments_list.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key, required this.model}) : super(key: key);
  final DoctorModel model;
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  DoctorModel? model;
  final FocusNode myFocusNode = FocusNode();
  String name = '';
  int patient_id = 0;
  late TabController _tabController;
  DateTime currentDate = DateTime.now();
  bool loading = false;
  static List<Time> hours = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isloading1 = false;
  bool isloading2 = false;

  TextEditingController dateEditingController = TextEditingController();
  TextEditingController hourEditingController = TextEditingController();

  String? _hour, _minute, _time;

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
      selectedTime.hour < 10
          ? _hour = "0${selectedTime.hour}"
          : _hour = selectedTime.hour.toString();
      selectedTime.minute < 10
          ? _minute = "0${selectedTime.minute}"
          : _minute = selectedTime.minute.toString();

      hourEditingController.text = "${_hour!}:${_minute!}";
    }
  }

  final String _value = "09:00";

  // _loadUser() async {
  //   preferences = await SharedPreferences.getInstance();

  //   if (preferences.getInt('id') != null) {
  //     setState(() {
  //       patient_id = preferences.getInt('id');
  //     });
  //   }
  // }

  @override
  void initState() {
    model = widget.model;
    _tabController = TabController(length: 6, vsync: this);
    //_loadUser();
    super.initState();
  }

  _appbar() {
    return AppBar(
      elevation: 0,
      title: Text(
        "${LocaleKeys.appointment_with.tr} ${model?.name ?? ""}",
        style: TextStyle(color: Theme.of(context).hoverColor),
      ),
      backgroundColor: kPrimaryColor,
      leading: Builder(
        builder: (context) => // Ensure Scaffold is in context
            const BackButton(color: Colors.white),
      ),
    );
  }

  _getAppointmentPlannings(String day) async {
    // Dio dio = Dio(ApiConnexion().baseOptions());
    try {
      var response = await http
          .get(Uri.parse('$kEndPoint/appointment-planning/${model?.id}/$day'));
      if (response.statusCode == 200) {
        print("dio$response");
        return jsonDecode(response.body);
      } else {
        var json = {"data": []};
        var data = jsonEncode(json);
        return jsonDecode(data);
      }
    } catch (e) {
      log(e.toString(), name: "Appoitnment plans get");
    }
  }

  Widget TimesFound(String day) {
    return FutureBuilder(
        future: _getAppointmentPlannings(day),
        builder: (context, snap) {
          log(snap.data.toString());
          var data = jsonEncode(snap.data);
          final decodedData = jsonDecode(data);
          if ((snap.connectionState == ConnectionState.none &&
                  snap.hasData == null) ||
              (snap.hasData == false) ||
              (snap.connectionState == ConnectionState.waiting)) {
            return const Center(child: Text(". . ."));
          }

          if (snap.connectionState == ConnectionState.done &&
              decodedData['data'].length == 0) {
            return Container(
              child: Center(
                child: Text(
                  LocaleKeys.no_data_found.tr,
                  //style: GoogleFonts.roboto(color: Colors.grey),
                ),
              ),
            );
          }

          if (snap.hasData) {
            List<Widget> notifs = [];
            decodedData['data']?.forEach((item) {
              item['start_times'].forEach((item) {
                notifs.add(doctorTimingsData(item));
              });
            });
            return ListView(
              scrollDirection: Axis.horizontal,
              children: notifs,
            );
          }
          return const Center(child: Text(". . ."));
        });
  }

  /*Widget TimesFound2(String day) {
    return FutureBuilder(
        future: _getAppointmentPlannings(day),
        builder: (context, snap) {
          if ((snap.connectionState == ConnectionState.none &&
              snap.hasData == null) ||
              (snap.hasData == false) ||
              (snap.connectionState == ConnectionState.waiting)) {
            return Center(child: Text(". . ."));
          }

          if (snap.connectionState == ConnectionState.done &&
              snap.data['data'].length == 0) {
            return Container(
              child: Center(
                child: Text(
                  'Aucune donnée trouvée',
                  //style: GoogleFonts.roboto(color: Colors.grey),
                ),
              ),
            );
          }

          if(snap.hasData)
          {
            List<DropdownMenuItem<String>> dropDownItems = [];
            
            snap.data['data'].forEach((item)
            {
              item['start_times'].forEach((item)
              {
                dropDownItems.add(
                    DropdownMenuItem(
                      child: Text("$item"),
                      value: item,
                    )
                );
                //notifs.add(doctorTimingsData(item));
              });

            });
            return DropdownButton(
                onChanged: (String value) {
                  setState(() {
                    _value = value;
                  });
                },
                value: _value,
                items: dropDownItems,
                hint:Text("Nombre de places")
            );
          }
          return Center(child: Text(". . ."));
        });
  }*/

  Widget doctorTimingsData(String time) {
    return Container(
      height: 6,
      margin: const EdgeInsets.only(left: 20, top: 10),
      decoration: BoxDecoration(
        color: const Color(0xff107163),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 2),
            child: const Icon(
              Icons.access_time,
              color: Colors.white,
              size: 18,
            ),
          ),
          Container(margin: const EdgeInsets.only(left: 2), child: Text(time)),
        ],
      ),
    );
  }

  /*Future<List<Time>> fetchHours(String day) async {
    final response = await http.get(
      Uri.parse(ApiConnexion.baseUrl+'/appointment-planning/' + model.id.toString() + '/' + day),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200)
    {
      hourController.text = "";
      final parsed = json.decode(response.body)['data'].cast<Map<String, dynamic>>();

      List<Time> findHours = parsed.map<Time>((json) => Time.fromMap(json)).toList();
      setState(() {
        hours = findHours;
      });

      print("jj"+ hours[0].start_times);

      for(int i=0; i<hours.length; i++)
      {
        hourEditingController.text += hours[i].start_times;
      }

      return findHours;
    } else {
      throw Exception('Failed to load hours');
    }
  }*/

  void _requestAppointment() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          isloading2 = true;
        });
        // Dio dio = Dio(ApiConnexion().baseOptions());

        String date = dateEditingController.text;
        String hour = hourEditingController.text;
        final user = Get.find<UserController>().user;
        var body = {
          'date': date,
          'time': hour,
          'patient_id': user.id.toString(),
          'doctor_id': model?.id.toString(),
        };
        log(body.toString(), name: "VALUE");
        var response = await http
            .post(Uri.parse('$kEndPoint/enquire-appointment'), body: body);
        //widget.onChangedStep(1)

        setState(() {
          isloading2 = false;
        });

        if (response.statusCode == 200) {
          final decodedData = jsonDecode(response.body);
          log(decodedData.toString(), name: "APOITMENT");
          if (decodedData["success"] == true) {
            print(decodedData);
            AlertDialog dialog = AlertDialog(
              title: const Text('Info'),
              content: Text(decodedData["message"].toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAppointmentsPage(),
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
            final user = Get.find<UserController>().user;

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return dialog;
              },
            );
            Config().sendNotification(
                token: user.fcmToken ?? "",
                title: user.name ?? "",
                body: decodedData["message"].toString());
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
          log(response.body.toString(), name: "MAKE APPOINTMENT ERROR");
        }
      } catch (e) {
        Get.snackbar(
          "OOPS",
          e.toString(),
        );
      }

      setState(() {
        isloading2 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      appBar: _appbar(),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Image.asset(
                'assets/images/rdv.jpg',
                fit: BoxFit.cover,
                height: 230.0,
                width: double.infinity,
              ),
              Container(
                color: Theme.of(context).cardColor,
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
                                  Text(
                                    'Informations ${LocaleKeys.my_appointments.tr}',
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      TabBar(
                        unselectedLabelColor: Theme.of(context).hoverColor,
                        labelColor: Theme.of(context).hoverColor,
                        isScrollable: true,
                        tabs: [
                          Tab(
                            text: LocaleKeys.monday.tr,
                          ),
                          Tab(
                            text: LocaleKeys.tuesday.tr,
                          ),
                          Tab(
                            text: LocaleKeys.wednesday.tr,
                          ),
                          Tab(
                            text: LocaleKeys.thursday.tr,
                          ),
                          Tab(
                            text: LocaleKeys.firday.tr,
                          ),
                          Tab(
                            text: LocaleKeys.starday.tr,
                          ),
                        ],
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (i) {
                          print(i);
                          //fetchHours("Lundi");
                        },
                      ),
                      SizedBox(
                        height: 100,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Center(child: TimesFound('Lundi')),
                            Center(child: TimesFound('Mardi')),
                            Center(child: TimesFound('Mercredi')),
                            Center(child: TimesFound('Jeudi')),
                            Center(child: TimesFound('Venredi')),
                            Center(child: TimesFound('Samedi')),
                          ],
                        ),
                      ),
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
                                        children: <Widget>[
                                          Text(
                                            LocaleKeys.appointment_date.tr,
                                            style: const TextStyle(
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
                                              return "Veuillez préciser la date";
                                            }
                                            return null;
                                          },
                                          // validator: (val) {
                                          //   return val.isEmpty
                                          //       ? "Veuillez préciser la date"
                                          //       : null;
                                          // },
                                          controller: dateEditingController,
                                          decoration: InputDecoration(
                                            hintText:
                                                LocaleKeys.appointment_date.tr,
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFb1b2c4),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: kPrimaryColor),
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
                                              Icons.calendar_today,
                                              color: Color(0xFF6aa6f8),
                                            ),
                                            //
                                          ),
                                          onTap: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            showDatePicker(
                                              context: context,
                                              cancelText: "ANNULER",
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2019, 1),
                                              lastDate: DateTime(2221, 12),
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    colorScheme:
                                                        const ColorScheme.light(
                                                      primary:
                                                          kPrimaryColor, // header background color
                                                      onPrimary: Colors
                                                          .black, // header text color
                                                      //onSurface: sonefBlue, // body text color
                                                    ),
                                                    textButtonTheme:
                                                        TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor: Colors
                                                            .red, // button text color
                                                      ),
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            ).then((pickedDate) {
                                              if (pickedDate != null) {
                                                String pickedDatef =
                                                    DateFormat("d-M-y")
                                                        .format(pickedDate);

                                                dateEditingController.text =
                                                    pickedDatef;
                                              }
                                            });
                                          },
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
                                        children: <Widget>[
                                          Text(
                                            LocaleKeys.appointment_hour.tr,
                                            style: const TextStyle(
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
                                              return "Veuillez préciser l'heure";
                                            }
                                            return null;
                                          },
                                          // validator: (val) {
                                          //   return val.isEmpty
                                          //       ? "Veuillez préciser l'heure"
                                          //       : null;
                                          // },
                                          controller: hourEditingController,
                                          decoration: InputDecoration(
                                            hintText:
                                                LocaleKeys.appointment_hour.tr,
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
                                              Icons.lock_clock,
                                              color: Color(0xFF6aa6f8),
                                            ),
                                          ),
                                          onTap: () {
                                            _selectTime(context);
                                          },
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
                                          _requestAppointment();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF4894e9),
                                            padding: const EdgeInsets.all(15),
                                            shape: const StadiumBorder()),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            LocaleKeys.submit.tr,
                                            style: const TextStyle(
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
