import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../../../../components/ChattingPage.dart';
import '../../../../constants.dart';
import 'chat_for_chats_screen.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  // List allUsers = [];
  var allUsersWithDetails = [];
  // String currentuserid;
  // String currentusername;
  // String currentuserphoto;
  // SharedPreferences preferences;
  // bool isLoading = false;

  @override
  initState() {
    super.initState();
    _getUsersDetails();
  }

  // getCurrUserId() async {
  //   preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     currentuserid = preferences.getString("uid");
  //     currentusername = preferences.getString("name");
  //     currentuserphoto = preferences.getString("photo");
  //   });
  // }

  _getUsersDetails() async {
    final user = Get.find<UserController>().user;
    //await getCurrUserId();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("isDoctor", isEqualTo: false)
        .get();

    setState(() {
      allUsersWithDetails = querySnapshot.docs;
      allUsersWithDetails.removeWhere((element) => element["uid"] == user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
              letterSpacing: 1.25,
              fontSize: 20,
              color: Theme.of(context).hoverColor),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).hoverColor),
        actions: [
          GetBuilder<UserController>(builder: (cont) {
            return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(
                        allUsersList: allUsersWithDetails,
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
                    .doc(cont.user.uid)
                    .collection("chatList")
                    .orderBy("timestamp", descending: true)
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
                  } else if (snapshot.data!.docs.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).copyWith().size.height -
                          MediaQuery.of(context).copyWith().size.height / 5,
                      width: MediaQuery.of(context).copyWith().size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Aucune conversation récente",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Démarrer une discussion",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: snapshot.data?.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // return const Text("Hey");
                        return ChatChatsScreen(
                          data: snapshot.data?.docs[index],
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

// Search Bar

class DataSearch extends SearchDelegate {
  DataSearch(
      {required this.allUsersList,
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
    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                close(context, null);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Chat(
                    recieverPhone: suggestionList[index]["phone"] ?? "",
                    recieverToken: suggestionList[index]["fcmToken"] ?? "",
                    receiverId: suggestionList[index]["uid"] ?? "",
                    receiverAvatar: suggestionList[index]["photoUrl"] ?? "",
                    receiverName: suggestionList[index]["name"] ?? "",
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
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionList[index]["name"]
                              .toLowerCase()
                              .substring(query.length),
                          style: const TextStyle(color: Colors.grey))
                    ]),
              ),
            ),
        itemCount: suggestionList.length);
  }
}
