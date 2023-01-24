
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../../../../components/ChattingPage.dart';
import '../../../../components/StatusIndicator.dart';


class ChatChatsScreen extends StatefulWidget {
  final dynamic data;

  const ChatChatsScreen({
    required this.data,
  });
  @override
  _ChatChatsScreenState createState() => _ChatChatsScreenState();
}

class _ChatChatsScreenState extends State<ChatChatsScreen> {
  // String currentuserid;
  // String currentusername;
  // String currentuserphoto;
  // SharedPreferences preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getCurrUser();
  }

  // getCurrUser() async {
  //   preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     currentuserid = preferences.getString("uid");
  //     currentusername = preferences.getString("name");
  //     currentuserphoto = preferences.getString("photo");
  //   });
  // }

  String checkDate() {
    DateTime today = DateTime.now();
    DateTime curr = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.data["timestamp"]));
    if (curr.year == today.year &&
        curr.month == today.month &&
        curr.day == today.day) {
      return DateFormat("hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(
          int.parse(widget.data["timestamp"])));
    } else if (curr.year == today.year &&
        curr.month == today.month &&
        curr.day == (today.day - 1)) {
      return "Yesterday";
    } else {
      return DateFormat("dd / MM / yyyy").format(
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(widget.data["timestamp"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (cont) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(widget.data["id"])
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  // child: Text("User details not found"),
                  );
            } else {
              var data=jsonEncode(snapshot.data!.data());
              final decodedData=jsonDecode(data);
              return InkWell(
                onTap: () {
                  // print(widget.data["content"]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Chat(
                      receiverId: decodedData["uid"],
                      receiverAvatar: decodedData["photoUrl"],
                      receiverName: decodedData["name"],
                      currUserId: cont.user.uid??"",
                      currUserName: cont.user.name??"",
                      currUserAvatar: cont.user.photoUrl??"",
                    );
                  }));
                },
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(decodedData["photoUrl"]),
                                  maxRadius: 30,
                                ),
                                Positioned(
                                  left: 0,
                                  top: 30,
                                  child: StatusIndicator(
                                    uid: widget.data["id"],
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
                                    Text(decodedData["name"]),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    RichText(
                                        text: TextSpan(children: [
                                      widget.data["showCheck"]
                                          ? WidgetSpan(
                                              child: Container(
                                              padding: const EdgeInsets.only(right: 5),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.blueAccent,
                                                size: 16,
                                              ),
                                            ))
                                          : const TextSpan(),
                                      TextSpan(
                                        text: widget.data["type"] == 3
                                            ? "Sticker"
                                            : widget.data["type"] == 2
                                                ? "GIF"
                                                : widget.data["type"] == 1
                                                    ? "IMAGE"
                                                    : widget.data["type"] == -1
                                                        ? widget.data["content"]
                                                            .toString()
                                                        : widget.data["content"]
                                                                    .toString()
                                                                    .length >
                                                                30
                                                            ? "${widget.data["content"]
                                                                    .toString()
                                                                    .substring(
                                                                        0, 30)}..."
                                                            : widget.data["content"]
                                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade500),
                                      ),
                                    ])),
                                    // Text(
                                    //   widget.data["type"] == 3
                                    //       ? "Sticker"
                                    //       : widget.data["type"] == 2
                                    //           ? "GIF"
                                    //           : widget.data["type"] == 1
                                    //               ? "IMAGE"
                                    //               : widget.data["content"]
                                    //                           .toString()
                                    //                           .length >
                                    //                       30
                                    //                   ? widget.data["content"]
                                    //                           .toString()
                                    //                           .substring(0, 30) +
                                    //                       "..."
                                    //                   : widget.data["content"]
                                    //                       .toString(),
                                    //   style: TextStyle(
                                    //       fontSize: 14,
                                    //       color: Colors.grey.shade500),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        checkDate(),
                        style: const TextStyle(
                          fontSize: 12,
                          // color: widget.isMessageRead
                          //     ? Colors.pink
                          //     : Colors.grey.shade500
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        );
      }
    );
  }
}
