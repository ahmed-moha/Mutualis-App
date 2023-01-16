import 'package:flutter/material.dart';


import '../constants.dart';

class Seprator extends StatelessWidget {
  const Seprator({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);
  final String title;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kPadding),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: kPadding),
        ),
        Visibility(
          visible: onPressed!=null,
          child: TextButton(
            onPressed: onPressed,
            child: const Text(
              "More",
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: kPrimaryColor),
            ),
          ),
        )
      ]),
    );
  }
}
