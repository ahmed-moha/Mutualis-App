import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../../../components/chat_for_users_list.dart';
import '../../../constants.dart';
import 'AddDoctor.dart';

class AdminView extends GetView {
  const AdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: const Text("Doctors"),
        centerTitle: true,
        actions: [
          GetBuilder<UserController>(builder: (cont) {
            return IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: ()=> cont.logOut(),
                        child: const Text("Yes"),
                      ),
                       TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(IconlyLight.logout),
            );
          })
        ],
      ),
      body: const AdminScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDoctorPage(),
            ),
          );
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (cont) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("isDoctor", isEqualTo: true)
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
                    // allUsersList = snapshot.data?.docs;
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: snapshot.data?.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        //log(snapshot.data?.docs[index].toString(),name: "ALL DATA");
                        return ChatUsersList(
                         // phone:snapshot.data?.docs[index]["phone"]==null? "":snapshot.data?.docs[index]["phone"] ?? "",
                          fcmToken:
                              snapshot.data?.docs[index]["fcmToken"] ?? "",
                          name: snapshot.data?.docs[index]["name"] ?? "",
                          image: snapshot.data?.docs[index]["photoUrl"] ?? "",
                          time: snapshot.data?.docs[index]["createdAt"] ?? "",
                          email: snapshot.data?.docs[index]["email"] ?? "",
                          isMessageRead: true,
                          userId: snapshot.data?.docs[index]["uid"] ?? "",
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
