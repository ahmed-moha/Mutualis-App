import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jbuti_app/app/constants.dart';

import '../../../../generated/locales.g.dart';

class InformationsPage extends StatefulWidget {
  @override
  _InformationsState createState() => _InformationsState();
}

class _InformationsState extends State<InformationsPage> {
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //Alice alice = Alice();

  /*_registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token) => print(token));
  }*/

  @override
  void initState() {
    super.initState();

    /*_registerOnFirebase();
    checkNotifications();
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));*/
  }

  /*checkNotifications() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        final data = message['data'];

        setState(() {

        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['notification'];
        final data = message['data'];
        setState(() {

        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final notification = message['notification'];
        final data = message['data'];
        setState(() {

        });

      },
    );
  }*/

  _getMyMessages() async {
    try {
      var response = await http.get(Uri.parse('$kEndPoint/actualities'));
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

  Widget NotificationsFound() {
    return FutureBuilder(
        future: _getMyMessages(),
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
              return const Center(
                child: Text(
                  'Aucune notification trouvée',
                  //style: GoogleFonts.roboto(color: Colors.grey),
                ),
              );
            }
          }
          var r = jsonEncode(snap.data);
          var data = jsonDecode(r);
          List<Widget> notifs = [];
          data['data'].forEach((item) {
            notifs.add(WidgetNotification(item['title'], item['body'],
                item['created_at'], item['image']));
          });
          return ListView(
            children: notifs,
          );
        });
  }

  Widget WidgetNotification(
      String title, String content, String date, String image) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Card(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Container(
            padding:
                const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kPrimaryColor,
                  ),
                  child: image == null
                      ? Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          image,
                          fit: BoxFit.fill,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(title), Text(date)],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          content == null ? const Text('') : Text(content),
                          //Text(date)
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(''),
                          //isNull(date) ? Text('') : Text(date)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
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
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppTheme.randomColor(context),
                ),
                child: image == null ? Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.fill,
                ): Image.network(image,
                  fit: BoxFit.fill,
                ),
              ),
              ListTile(
                //contentPadding: EdgeInsets.all(0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(13)),

                ),
                title: Text(title, style: TextStyles.title),
                subtitle: Text(
                  date,
                  style: TextStyles.bodySm,
                ),
              ),
              Text(content),
            ],
          )),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:  Text(LocaleKeys.information.tr),
        backgroundColor: kPrimaryColor,
      ),
      body: NotificationsFound(),
    );
  }
}
