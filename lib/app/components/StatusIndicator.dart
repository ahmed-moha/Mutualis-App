import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:jbuti_app/app/components/utils.dart';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../constants.dart';
import 'enum/user_state.dart';
import 'user_state_methods.dart';

class StatusIndicator extends StatelessWidget {
  final String uid;
  final String screen;
  final UserStateMethods userStateMethods = UserStateMethods();

  StatusIndicator({required this.uid, required this.screen});
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return StreamBuilder(
      stream: userStateMethods.getUserStream(uid: uid),
      builder: (context, snapshot) {
        Object? user;
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
        }
        user = snapshot.data?.data();
        //print("THE USER INFO: $user");
        final data = jsonEncode(user);
        final decodedData = jsonDecode(data);
        if (screen == "chatDetailScreen") {
          //return const Text("TIGER");
          return Text(
            decodedData["state"] == 1
                ? "En ligne"
                : "Vu la dernière fois le ${DateFormat("dd MMMM, hh:mm", "fr").format(DateTime.fromMillisecondsSinceEpoch(int.parse(decodedData["lastSeen"])))}",
            style: TextStyle(
                color: decodedData["state"] == 1
                    ? getColor(decodedData["state"])
                    : Colors.grey,
                fontSize: 12),
          );
        } else {
          return Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: getColor(decodedData["state"])),
            margin: const EdgeInsets.only(top: 15),
          );
        }
      },
    );
  }
}
