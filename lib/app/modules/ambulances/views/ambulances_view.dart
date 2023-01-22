import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ambulances_controller.dart';

class AmbulancesView extends GetView<AmbulancesController> {
  const AmbulancesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AmbulancesView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AmbulancesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
