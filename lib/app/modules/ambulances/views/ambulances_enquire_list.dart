import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/data/doctor_model.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../../../../generated/locales.g.dart';

class MyAmbulancesPage extends StatefulWidget {
  //DossierPatientPage() : super(key: key);

  @override
  MyAmbulancesPageState createState() => MyAmbulancesPageState();
}

class MyAmbulancesPageState extends State<MyAmbulancesPage> {
  DoctorModel model = DoctorModel();
  final bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String name = '';
  //int _userId;
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
    super.initState();
    //_loadUser();
  }

  _getDossier() async {
    try {
      final user = Get.find<UserController>().user;
      var response = await http
          .get(Uri.parse('$kEndPoint/ambulance-enquirements/${user.id}'));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return decodedData;
      } else {
        throw response.body;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  _appbar() {
    return AppBar(
      elevation: 0,
      title:  Text(LocaleKeys.my_ambulances.tr),
      backgroundColor: kPrimaryColor,
      leading: Builder(
        builder: (context) => // Ensure Scaffold is in context
            const BackButton(color: Colors.white),
      ),
    );
  }

  Widget AmbulancesFound() {
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
            notifs.add(AppointmentWidget(item['location'], item['time'].toString(),
                item['created_at'].toString(), item['ambulance']['nom'], item['done'].toString()));
          });
          return ListView(
            children: notifs,
          );
        });
  }

  Widget AppointmentWidget(String lieu, String details, String createdAt,
      String ambulanceName, String statut) {
    /*return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 10,
            color: LightColor.grey.withOpacity(.2),
          ),
          BoxShadow(
            offset: Offset(-3, 0),
            blurRadius: 15,
            color: LightColor.grey.withOpacity(.1),
          )
        ],
      ),
      child: Container(
          //padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppTheme.randomColor(context),
                    ),
                  ),
                ),
                title: Text("RDV avec " + doctorName, style: TextStyles.title),
                subtitle: Text(
                  "Date : " + dateRdv,
                  style: TextStyles.bodySm,
                ),
              ),
              Text("RDV demandé le " + (created_at)),
            ],
          )),
    );*/

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Card(
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
                  child: Text(statut == "0" ? LocaleKeys.on_the_way.tr : "Déjà arrivé",
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
                          Text("Ambulance name $ambulanceName",
                              style: const TextStyle())
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
                            Text("Date : $createdAt"),
                          ]),
                          Row(children: <Widget>[
                            const Text("Description des faits"),
                            Text(details)
                          ])
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text("RDV demandé le $createdAt"))
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
              'assets/images/ambulance.jpg',
              fit: BoxFit.cover,
              height: 230.0,
              width: double.infinity,
            ),
            Expanded(child: AmbulancesFound())
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
