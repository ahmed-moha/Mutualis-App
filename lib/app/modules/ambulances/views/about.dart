import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../constants.dart';


class AboutPage extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<AboutPage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget aboutBody() {
    return SingleChildScrollView(
      //padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
      child: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/images/logo.jpeg',
            width: 250,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "MutualisApp v1.2.0",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Copyright @2023",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text("Mutualis App",
              textAlign: TextAlign.center, style: TextStyle(height: 1.8)
              //GoogleFonts.roboto(color: Colors.grey),
              ),
          const Text(
            "Application mobile de prise de rdv avec des médécins de Djibouti. "
            "Possibilité de chat, appels videos, suivi de dossier médical",
            textAlign: TextAlign.center,
            //GoogleFonts.roboto(color: Colors.grey),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title:  Text(LocaleKeys.home.tr),
          backgroundColor: kPrimaryColor,
          /*leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
          BackButton(color: Colors.white),
        ),*/
        ),
        body: aboutBody(),
      );
  }
}
