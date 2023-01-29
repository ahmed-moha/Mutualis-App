import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../../../../components/ChattingPage.dart';
import '../../../../components/chat_for_users_list.dart';
import '../../../../constants.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  // List allUsers = [];
  var allUsersList;
  // String currentuserid;
  // String currentusername;
  // String currentuserphoto;
  // SharedPreferences preferences;

  @override
  initState() {
    super.initState();
    // getCurrUserId();
  }

  // getCurrUserId() async {
  //   preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     currentuserid = preferences.getString("uid");
  //     currentusername = preferences.getString("name");
  //     currentuserphoto = preferences.getString("photo");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patients',
          style: TextStyle(
              letterSpacing: 1.25,
              fontSize: 20,
              color: Theme.of(context).hoverColor),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).hoverColor),
        elevation: 0,
        centerTitle: true,
        actions: [
          GetBuilder<UserController>(builder: (cont) {
            return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(
                        allUsersList: allUsersList,
                        currentuserid: cont.user.uid ?? "",
                        currentusername: cont.user.name ?? "",
                        currentuserphoto: cont.user.photoUrl ?? ""));
              },
            );
          })
        ],
      ),
      body: GetBuilder<UserController>(builder: (cont) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("isDoctor", isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.of(context).copyWith().size.height -
                          MediaQuery.of(context).copyWith().size.height / 5,
                      width: MediaQuery.of(context).copyWith().size.width,
                      child: const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                          kPrimaryColor,
                        )),
                      ),
                    );
                  } else {
                    snapshot.data?.docs
                        .removeWhere((i) => i["uid"] == cont.user.uid);
                    allUsersList = snapshot.data?.docs;
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: snapshot.data?.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        //return const Text("HELLO");
                        return ChatUsersList(
                         // phone:snapshot.data?.docs[index]["phone"]??"" ,
                          fcmToken: snapshot.data?.docs[index]["fcmToken"]??"",
                          name: snapshot.data?.docs[index]["name"]??"",
                          image: snapshot.data?.docs[index]["photoUrl"]??"",
                          time: snapshot.data?.docs[index]["createdAt"]??"",
                          email: snapshot.data?.docs[index]["email"]??"",
                          isMessageRead: true,
                          userId: snapshot.data?.docs[index]["uid"]??"",
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class DataSearch extends SearchDelegate {
  DataSearch(
      {this.allUsersList,
      required this.currentuserid,
      required this.currentusername,
      required this.currentuserphoto});
  var allUsersList;
  final String currentuserid;
  final String currentusername;
  final String currentuserphoto;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading Icon on left of appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on selection

    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when someone searches for something
    var userList = [];
    allUsersList.forEach((e) {
      userList.add(e);
    });
    var suggestionList = userList;

    if (query.isNotEmpty) {
      suggestionList = [];
      for (var element in userList) {
        if (element["name"].toLowerCase().startsWith(query.toLowerCase())) {
          suggestionList.add(element);
        }
      }
    }

    // suggestionList = query.isEmpty
    //     ? suggestionList
    //     : suggestionList
    //         .where((element) => element.startsWith(query.toLowerCase()))
    //         .toList();

    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                close(context, null);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Chat(
                    recieverPhone: suggestionList[index]["fcmToken"]??"",
                    recieverToken: suggestionList[index]["fcmToken"]??"",
                    receiverId: suggestionList[index]["uid"]??"",
                    receiverAvatar: suggestionList[index]["photoUrl"]??"",
                    receiverName: suggestionList[index]["name"]??"",
                    currUserId: currentuserid,
                    currUserName: currentusername,
                    currUserAvatar: currentuserphoto,
                  );
                }));
              },
              leading: const Icon(Icons.person),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index]["name"]
                        .toLowerCase()
                        .substring(0, query.length),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                    children: [
                      TextSpan(
                          text: suggestionList[index]["name"]
                              .toLowerCase()
                              .substring(query.length),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16))
                    ]),
              ),
            ),
        itemCount: suggestionList.length);
  }
}
