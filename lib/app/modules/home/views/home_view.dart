import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/modules/home/views/admin_view.dart';
import 'package:jbuti_app/app/modules/home/views/doctor_view.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../controllers/home_controller.dart';
import 'patient_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: GetBuilder<UserController>(builder: (cont) {
        if (cont.isAdmin) {
          return const AdminView();
        } else if (cont.isDoctor) {
          return const DoctorView();
        } else {
          return const Phome();
        }
      }),
    );
  }
}



class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (cont) {
      return Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello,"),
            const SizedBox(
              height: 5,
            ),
            Text(
              cont.user.name ?? "",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    });
  }
}
