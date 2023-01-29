
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'StatusIndicator.dart';

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String receiverAvatar;
  final String receiverName;
  final String receiverId;
  final String receiverPhone;
final String recieverFcmToken;
  final String currUserId;
  final String currUserAvatar;
  final String currUserName;

  const ChatDetailPageAppBar({
    Key? key,
    required this.receiverAvatar,
    required this.receiverName,
    required this.receiverId,
    required this.currUserAvatar,
    required this.currUserName,
    required this.currUserId, required this.recieverFcmToken, required this.receiverPhone,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 15,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: _buidVoiceVideoCall(context)
            /*FutureBuilder(
              future: Firestore.instance
                  .collection("Users")
                  .where("uid", isEqualTo: currUserId)
                  .where("isDoctor", isEqualTo: true)
                  .getDocuments(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                }

                if (snapshot.hasData) {
                  if (snapshot.data.documents.length > 0) {
                    return _buidVoiceVideoCall(context);
                  } else {
                    return _buidVideoCall(context);
                  }
                }
                ;
              }),*/
            ),
      ),
    );
  }

  _getUsersDetails(context) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("uid", isEqualTo: currUserId)
        .where("isDoctor", isEqualTo: true)
        .get();

    return _buidVideoCall(context);
  }

  Widget _buidVoiceVideoCall(BuildContext context) {
    String channelId;
    String token;
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        CircleAvatar(
          backgroundImage: NetworkImage(receiverAvatar),
          maxRadius: 20,
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                receiverName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 6,
              ),
              StatusIndicator(
                uid: receiverId,
                screen: "chatDetailScreen",
              )
            ],
          ),
        ),
        // IconButton(
        //   icon: Icon(
        //     Icons.video_call,
        //     color: Colors.grey.shade700,
        //   ),
        //   onPressed: () {},
        // ),
        IconButton(
          icon: Icon(
            Icons.call,
            color: Colors.grey.shade700,
          ),
          onPressed: ()  =>launchWhatsApp(receiverPhone),
        ),
      ],
    );
  }
  void launchWhatsApp(String number) async {
    try {
      print("THE NUMBER IS: $number");
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
  Widget _buidVideoCall(BuildContext context) {
    String channelId;
    String token;
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        CircleAvatar(
          backgroundImage: NetworkImage(receiverAvatar),
          maxRadius: 20,
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                receiverName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 6,
              ),
              StatusIndicator(
                uid: receiverId,
                screen: "chatDetailScreen",
              )
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.video_call,
            color: Colors.grey.shade700,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
