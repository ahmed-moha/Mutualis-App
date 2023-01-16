import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/appointments_controller.dart';

class AppointmentsView extends GetView<AppointmentsController> {
  const AppointmentsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppointmentsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AppointmentsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
