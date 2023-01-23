import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DoctorView extends GetView {
  const DoctorView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DoctorView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DoctorView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
