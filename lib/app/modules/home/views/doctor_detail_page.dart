import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/data/doctor_model.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../generated/locales.g.dart';
import '../../../components/ChattingPage.dart';
import 'appointment.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    Key? key,
    required this.doctor,
  }) : super(key: key);
  final DoctorModel doctor;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with WidgetsBindingObserver {
  bool loading = false;
  var availableAbonnement = true;
  /*loadPrefData() async
  {
    try{
      preferences = await SharedPreferences.getInstance();
      String dateAbonnement = preferences.getString("dateAbonnement");
      int dateAbonnementMillis = DateTime.parse(dateAbonnement).add(Duration(days: 10)).microsecondsSinceEpoch;
      int todayMillis = DateTime.now().microsecondsSinceEpoch;

      if(dateAbonnementMillis >= todayMillis)
      {
        setState(() {
          availableAbonnement = true;
        });
      }else{
        print("bad");
      }
    }catch(e){

    }
  }*/

  checkPayment(String doctorId) async {
    String patientId = Get.find<UserController>().user.id.toString();
    final response = await http.get(
      Uri.parse(
          "$kEndPoint/getPayment?patientId=$patientId&doctorId=$doctorId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      var jsResponse = jsonDecode(response.body);
      var paymentCreatedAt = DateTime.parse(jsResponse['created_at']);
      //String paymentCreatedAtFormated = new DateFormat(dateTimeFormat).format(paymentCreatedAt);

      int dateAbonnementMillis =
          paymentCreatedAt.add(const Duration(days: 10)).microsecondsSinceEpoch;
      int todayMillis = DateTime.now().microsecondsSinceEpoch;
      if (dateAbonnementMillis >= todayMillis) {
        setState(() {
          availableAbonnement = true;
        });
      } else {
        print("bad");
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    //checkPayment(widget.doctor.id.toString());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (cont) {
      return Scaffold(
        body: MyStatefulWidget(
            doctor: widget.doctor,
            currentuserid: cont.user.id.toString(),
            currentusername: cont.user.name ?? "",
            currentuserphoto: cont.user.photoUrl ?? "",
            availableAbonnement: availableAbonnement,
            loading: loading),
      );
    });
  }
}

class MyStatefulWidget extends StatefulWidget {
  final DoctorModel doctor;
  final String currentuserid;
  final String currentusername;
  final String currentuserphoto;
  final bool availableAbonnement;
  final bool loading;

  const MyStatefulWidget({
    Key? key,
    required this.doctor,
    required this.currentuserid,
    required this.currentusername,
    required this.currentuserphoto,
    required this.availableAbonnement,
    required this.loading,
  }) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Widget _appbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BackButton(color: Theme.of(context).primaryColor),
          const LikeButton(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).hoverColor);

    return Scaffold(
      //backgroundColor: LightColor.extraLightBlue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            //Image.network(widget.doctor.photo),
            Container(
              width: double.infinity,
              height: 300,
              //child: Image.asset("assets/icone.png", fit: BoxFit.contain,),
              decoration: BoxDecoration(
                //borderRadius: const BorderRadius.all(Radius.circular(30)),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: ExtendedNetworkImageProvider(
                        widget.doctor.photoUrl ?? ""),
                    fit: BoxFit.fill),
              ),
            ),
            DraggableScrollableSheet(
              maxChildSize: .8,
              initialChildSize: .6,
              minChildSize: .6,
              builder: (context, scrollController) {
                String channelId;
                String token;
                return Container(
                  height: MediaQuery.of(context).size.height * .5,
                  padding: const EdgeInsets.only(
                      left: 19,
                      right: 19,
                      top: 16), //symmetric(horizontal: 19, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Theme.of(context).cardColor,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.doctor.name ?? "",
                                style: titleStyle,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.check_circle,
                                  size: 18,
                                  color: Theme.of(context).primaryColor),
                              const Spacer(), /*
                              RatingStar(
                                rating: double.parse(widget.doctor.rating),
                              )*/
                            ],
                          ),
                          subtitle: Text(
                            widget.doctor.type ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(
                          thickness: 0.8,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          LocaleKeys.about.tr,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.doctor.description ?? '',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).hoverColor),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: const [
                            Image(
                              image: AssetImage("assets/images/waafi.png"),
                              width: 50,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Payer la téléconsultation par Waafi au : 3152",
                              style: TextStyle(
                                  color: Color(0xffdf4d12),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: const [
                            Image(
                              image: AssetImage("assets/images/dmoney.png"),
                              width: 50,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Payer la téléconsultation par DMoney",
                              style: TextStyle(
                                  color: Color(0xffdf4d12),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            _appbar(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "How do you want to contact the DR",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: ExtendedNetworkImageProvider(
                                widget.doctor.photoUrl ?? defaultPhotoUrl),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            widget.doctor.name ?? "",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>callPhone(number: widget.doctor.phone??""),
                        child: const Text(
                          "Call",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>launchWhatsApp(widget.doctor.phone??""),
                        child: const Text("What's App Call",
                            style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(
                  IconlyBold.call,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.availableAbonnement) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Chat(
                      recieverPhone: widget.doctor.phone??"",
                      recieverToken: widget.doctor.fcmToken ?? "",
                      receiverId: widget.doctor.uid ?? "",
                      receiverAvatar: widget.doctor.photoUrl ?? "",
                      receiverName: widget.doctor.name ?? "",
                      currUserId: widget.currentuserid,
                      currUserName: widget.currentusername,
                      currUserAvatar: widget.currentuserphoto,
                    );
                  }));
                } else {
                  // Navigator.push(context,
                  //     MaterialPageRoute(
                  //         builder: (context) {
                  //   return InitWaafiPaymentPage(
                  //       doctorId: widget.doctor.id
                  //           .toString(),
                  //       doctorType:
                  //           widget.doctor.type);
                  // }));
                }
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(
                  IconlyBold.chat,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.availableAbonnement) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AppointmentPage(model: widget.doctor),
                        ),
                      );
                    } else {
                      // Navigator.push(context,
                      //     MaterialPageRoute(
                      //         builder: (context) {
                      //   return InitWaafiPaymentPage(
                      //       doctorId:
                      //           widget.doctor.id.toString(),
                      //       doctorType: widget.doctor.type);
                      // }));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor, elevation: 0),
                  child: Text(LocaleKeys.make_appointment.tr),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void callPhone({required String number}) async {
    var phone = 'tel:$number';
    if (await canLaunchUrl(Uri.parse(phone))) {
      await launchUrl(Uri.parse(phone));
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('We couldn\'t call this phone. $number'),
        ),
      );
    }
  }

  void launchWhatsApp(String number) async {
    try {
      //String phoneNumber = '252615868999';
      String message = 'Assalamu alaykum!';
      var whatsappUrl = "whatsapp://send?phone=$number&text=$message";
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
              content: Text('Whatsapp is not installed in this phone!')),
        );
      }
    } catch (e) {
      print('on what\'s app ERROR:$e');
    }
  }
}
