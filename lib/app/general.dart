import 'dart:math';

import 'package:flutter/material.dart';

class General {
    Color randomColor(BuildContext context) {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      Colors.orange,
      Colors.green,
      Colors.grey,
      Colors.cyan,
      Colors.purple,
      Colors.orange,
      Colors.red,
      Colors.brown,
      Colors.blue,
      Colors.green,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }
}