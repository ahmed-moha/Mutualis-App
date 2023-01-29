import 'dart:convert';
import 'dart:developer';
import "package:intl/intl.dart";
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/data/doctor_model.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../../../../generated/locales.g.dart';

class MyAppointmentsPage extends StatefulWidget {
  //DossierPatientPage() : super(key: key);

  @override
  MyAppointmentsPageState createState() => MyAppointmentsPageState();
}

class MyAppointmentsPageState extends State<MyAppointmentsPage> {
  DoctorModel model = DoctorModel();
  final bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String name = '';

  DateTime currentDate = DateTime.now();
  //SharedPreferences preferences;

  // _loadUser() async {
  //   preferences = await SharedPreferences.getInstance();

  //   if (preferences.getInt('id') != null) {
  //     setState(() {
  //       _userId = preferences.getInt('id');
  //     });
  //   }
  // }

  @override
  void initState() {
    
    //_loadUser();
    super.initState();
  }

  _getDossier() async {
    try {
      final user = Get.find<UserController>().user;
      // Dio dio = Dio(ApiConnexion().baseOptions());
      var response = await http
          .get(Uri.parse('$kEndPoint/patient-appointments/${user.id}'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        throw response.body;
      }
      //print(response);

    } catch (e) {
      log(e.toString());
    }
  }

  _appbar() {
    return AppBar(
      elevation: 0,
      title:  Text(LocaleKeys.my_appointments.tr,style: TextStyle(
         color: Theme.of(context).hoverColor
      ),),
      backgroundColor: kPrimaryColor,
      leading: Builder(
        builder: (context) => // Ensure Scaffold is in context
            const BackButton(color: Colors.white),
      ),
    );
  }

  Widget AppointmentsFound() {
    return FutureBuilder(
        future: _getDossier(),
        builder: (context, snap) {
          if ((snap.connectionState == ConnectionState.none &&
                  snap.hasData == null) ||
              (snap.hasData == false) ||
              (snap.connectionState == ConnectionState.waiting)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasData) {
            var r = jsonEncode(snap.data);
            var data = jsonDecode(r);

            if (snap.connectionState == ConnectionState.done &&
                data['data'].length == 0) {
              return Container(
                child:  Center(
                  child: Text(
                  LocaleKeys.no_data_found.tr,
                    //style: GoogleFonts.roboto(color: Colors.grey),
                  ),
                ),
              );
            }
          }
          var r = jsonEncode(snap.data);
          var data = jsonDecode(r);
          List<Widget> notifs = [];
          data['data'].forEach((item) {
            notifs.add(AppointmentWidget(item['date'].toString(), item['time'].toString(),
                item['created_at'].toString(), item['doctor']['name'].toString(), item['done'].toString()));
          });
          return ListView(
            children: notifs,
          );
        });
  }

  Widget AppointmentWidget(String dateRdv, String heureRdv, String createdAt,
      String doctorName, String statut) {
        String date=DateFormat.yMMMMEEEEd().format(DateTime.parse(createdAt));
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Card(
        color:  Theme.of(context).cardColor,
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16),
        child: Container(
            padding:
                const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  color: statut == "0" ? Colors.yellow : Colors.green,
                  child: Text(statut == "0" ? "coming" : "Already done",
                      style: const TextStyle(
                          //color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Appointment with $doctorName", style:  TextStyle( color: Theme.of(context).hoverColor))
                          //new Text(startStation)
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: <Widget>[
                            const Icon(
                              Icons.calendar_today,
                              color: kPrimaryColor,
                              size: 16,
                            ),
                            Text("Date : $dateRdv",style:  TextStyle( color: Theme.of(context).hoverColor)),
                          ]),
                          const SizedBox(height: 5,),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.lock_clock,
                                  color: kPrimaryColor, size: 16),
                              Text("hour : $heureRdv",style:  TextStyle( color: Theme.of(context).hoverColor))
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text("Appointment requested on \n$date",style:  const TextStyle( color: kPrimaryColor)))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/rdv.jpg',
              fit: BoxFit.cover,
              height: 230.0,
              width: double.infinity,
            ),
            Expanded(child: AppointmentsFound())
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}
