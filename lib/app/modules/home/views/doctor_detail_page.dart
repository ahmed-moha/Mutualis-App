import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/data/doctor_model.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BackButton(color: Theme.of(context).primaryColor),
        const LikeButton(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle =
        const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  
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
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: ExtendedNetworkImageProvider(widget.doctor.photoUrl??""), fit: BoxFit.fill),
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
                  height:MediaQuery.of(context).size.height * .5,
                  padding: const EdgeInsets.only(
                      left: 19,
                      right: 19,
                      top: 16), //symmetric(horizontal: 19, vertical: 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
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
                                widget.doctor.name??"",
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
                            widget.doctor.type??"",
                            style: const TextStyle(
                                fontSize: 12 * 1.2,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(
                          thickness: .3,
                          color:Colors.grey,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text("A propos", style: titleStyle))),
                        Text(
                          widget.doctor.description ?? '',
                          style: const TextStyle(
                              fontSize: 14 * 1.2,
                              color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: widget.loading
                              ? const Center(child: CircularProgressIndicator())
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: widget.availableAbonnement
                                              ? const Color(0xffdf4d12)
                                              : Colors.cyan),
                                      child: IconButton(
                                          icon: const Icon(
                                            Icons.call,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            // if (widget.availableAbonnement) {
                                            //    await Permissions
                                            //           .cameraAndMicrophonePermissionsGranted()
                                            //       ? {
                                            //           channelId = Random()
                                            //               .nextInt(1000)
                                            //               .toString(),
                                            //           await CallUtils.getToken(
                                            //                   channelId)
                                            //               .then((res) {
                                            //             token = res;
                                            //             if (token != null) {
                                            //               CallUtils.call(
                                            //                   currUserId: widget
                                            //                       .currentuserid,
                                            //                   currUserName: widget
                                            //                       .currentusername,
                                            //                   currUserAvatar: widget
                                            //                       .currentuserphoto,
                                            //                   receiverId: widget
                                            //                       .doctor.uid,
                                            //                   receiverAvatar:
                                            //                       widget.doctor
                                            //                           .photo,
                                            //                   receiverName:
                                            //                       widget.doctor
                                            //                           .name,
                                            //                   voiceCall: true,
                                            //                   channelId:
                                            //                       channelId,
                                            //                   token: token,
                                            //                   context: context);
                                            //             }
                                            //           }),
                                            //         }
                                            //       : {};
                                            // } else {
                                            //   Navigator.push(context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) {
                                            //     return InitWaafiPaymentPage(
                                            //       doctorId: widget.doctor.id
                                            //           .toString(),
                                            //       doctorType:
                                            //           widget.doctor.type,
                                            //     );
                                            //   }));
                                            // }
                                          }),
                                      //  Navigator.pushReplacementNamed(context, "/call");
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: widget.availableAbonnement
                                                ? const Color(0xffdf4d12)
                                                : Colors.grey
                                                    .withAlpha(150)),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (widget.availableAbonnement) {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return Chat(
                                                  receiverId: widget.doctor.uid??"",
                                                  receiverAvatar:
                                                      widget.doctor.photoUrl??"",
                                                  receiverName:
                                                      widget.doctor.name??"",
                                                  currUserId:
                                                      widget.currentuserid,
                                                  currUserName:
                                                      widget.currentusername,
                                                  currUserAvatar:
                                                      widget.currentuserphoto,
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
                                          child: const Icon(
                                            Icons.chat_bubble,
                                            color: Colors.white,
                                          ),
                                        )
                                        //  Navigator.pushReplacementNamed(context, "/call");
                                        ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                    
                                      
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        if (widget.availableAbonnement) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AppointmentPage(
                                                      model: widget.doctor),
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
                                      child: const Text(
                                        "Prendre rendez-vous",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        Row(
                          children: const [
                            Image(
                              image: AssetImage("assets/images/waafi.png"),
                              width: 50,
                            ),
                            Text(
                              "Payer la téléconsultation par Waafi au : 3152",
                              style: TextStyle(
                                  color: Color(0xffdf4d12),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: const [
                            Image(
                              image: AssetImage("assets/images/dmoney.png"),
                              width: 50,
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
    );
  }
}
