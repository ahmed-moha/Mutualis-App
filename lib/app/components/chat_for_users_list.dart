
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jbuti_app/app/components/StatusIndicator.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import 'ChattingPage.dart';


class ChatUsersList extends StatefulWidget {
  final String name;
  // final String secondaryText;
  final String image;
  final String fcmToken;
  final String time;
  final bool isMessageRead;
  final String? phone;
  final String userId;
  final String email;
  // final String screen;
  const ChatUsersList(
      {required this.name,
      // @required this.secondaryText,
      required this.image,
      required this.time,
      required this.isMessageRead,
      required this.email,
      // @required this.screen,
      required this.userId, required this.fcmToken,  this.phone});
  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  // String currentuserid;
  // String currentusername;
  // String currentuserphoto;
  // SharedPreferences preferences;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getCurrUser();
  // }

  // getCurrUser() async {
  //   preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     currentuserid = preferences.getString("uid");
  //     currentusername = preferences.getString("name");
  //     currentuserphoto = preferences.getString("photo");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return GetBuilder<UserController>(
            builder: (cont) {
              return Chat(
                recieverPhone: widget.phone,
                receiverId: widget.userId,
                recieverToken: widget.fcmToken,
                receiverAvatar: widget.image,
                receiverName: widget.name,
                currUserId: cont.user.uid??"",
                currUserName: cont.user.name??"",
                currUserAvatar: cont.user.photoUrl??"",
              );
            }
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        margin: const EdgeInsets.all(8),
        decoration:  BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.image),
                        maxRadius: 30,
                      ),
                      Positioned(
                        left: 0,
                        top: 30,
                        child: StatusIndicator(
                          uid: widget.userId,
                          screen: "chatListScreen",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.email,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
