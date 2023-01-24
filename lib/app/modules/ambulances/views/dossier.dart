import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/data/doctor_model.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../generated/locales.g.dart';

class DossierPatientPage extends StatefulWidget {
  //DossierPatientPage() : super(key: key);

  @override
  DossierPatientPageState createState() => DossierPatientPageState();
}

class DossierPatientPageState extends State<DossierPatientPage> {
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
    // _loadUser();
    super.initState();
  }

  _getDossier() async {
    try {
      // Dio dio = Dio(ApiConnexion().baseOptions());
      final user = Get.find<UserController>().user;
      var response =
          await http.get(Uri.parse('$kEndPoint/patient-folder/${user.id}'));
      //print(response);
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
      title:  Text("${LocaleKeys.my_file.tr} ${LocaleKeys.patient.tr}",style:  TextStyle( color: Theme.of(context).hoverColor)),
      backgroundColor: kPrimaryColor,
      leading: Builder(
        builder: (context) => // Ensure Scaffold is in context
            const BackButton(color: Colors.white),
      ),
    );
  }

  Widget DossiersFound() {
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
            notifs.add(WidgetDossier(
                item['clinique'],
                item['parametres_vitaux'],
                item['antecedents'],
                item['diagnostic'],
                item['traitement'],
                item['bilan'],
                item['suivi'],
                item['date_consultation'],
                item['piece_jointe'],
                item['doctor']['name'],
                item['created_at']));
          });
          return ListView(
            children: notifs,
          );
        });
  }

  Widget WidgetDossier(
      String clinique,
      String parametresVitaux,
      String antecedents,
      String diagnostic,
      String traitement,
      String bilan,
      String suivi,
      String date,
      String pieceJointe,
      String doctorName,
      String createdAt) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color:  Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(4, 4),
            blurRadius: 10,
            color: Colors.grey.withOpacity(.2),
          ),
          BoxShadow(
            offset: const Offset(-3, 0),
            blurRadius: 15,
            color: Colors.grey.withOpacity(.1),
          )
        ],
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: Text("Consultation avec Dr $doctorName",
                    style:  const TextStyle()),
                subtitle: Text(
                  "Date : $date",
                  style:  TextStyle(color:  Theme.of(context).hoverColor),
                ),
                trailing: pieceJointe.isEmpty
                    ? const Text("Aucun fichier joint")
                    : IconButton(
                        onPressed: () async {
                          _launchURL(pieceJointe);
                        },
                        icon: const Icon(
                          Icons.file_present,
                          color: kPrimaryColor,
                        )),
              ),
              Row(children: <Widget>[
                const Icon(
                  Icons.local_hospital,
                  color: kPrimaryColor,
                  size: 16,
                ),
                Text("Clinique : $clinique"),
              ]),
              const SizedBox(
                height: 10,
              ),
              Row(children: <Widget>[
                const Icon(
                  Icons.local_hospital,
                  color: kPrimaryColor,
                  size: 16,
                ),
                Text("Parametres vitaux : $parametresVitaux"),
              ]),
              const SizedBox(height: 10),
              Row(children: <Widget>[
                const Icon(
                  Icons.local_hospital,
                  color: kPrimaryColor,
                  size: 16,
                ),
                Text("Diagnostic : $diagnostic"),
              ]),
              const SizedBox(height: 10),
              Row(children: <Widget>[
                const Icon(
                  Icons.local_hospital,
                  color: kPrimaryColor,
                  size: 16,
                ),
                Text("Antécédents : $antecedents"),
              ]),
              const SizedBox(height: 10),
              Row(children: <Widget>[
                const Icon(
                  Icons.local_hospital,
                  color: kPrimaryColor,
                  size: 16,
                ),
                Text("Traitement : $traitement"),
              ]),
              const SizedBox(height: 10),
              Row(children: <Widget>[
                const Icon(
                  Icons.local_hospital,
                  color: kPrimaryColor,
                  size: 16,
                ),
                Text("Bilan : $bilan"),
              ]),
              const SizedBox(height: 10),
              Row(children: <Widget>[
                const Icon(
                  Icons.local_hospital,
                  color: kPrimaryColor,
                  size: 16,
                ),
                Text("Suivi : $suivi"),
              ]),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/dossier.jpg',
              fit: BoxFit.cover,
              height: 230.0,
              width: double.infinity,
            ),
            Expanded(child: DossiersFound())
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  void _launchURL(String url) async =>
      await canLaunchUrl(Uri.parse(url)) ? await launchUrl(Uri.parse(url)) : throw 'Could not launch $url';
}
