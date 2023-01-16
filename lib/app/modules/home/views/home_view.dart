import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:jbuti_app/app/components/AppDrawer.dart';
import 'package:jbuti_app/app/components/category_card.dart';
import 'package:jbuti_app/app/components/seprator_card.dart';
import 'package:jbuti_app/app/constants.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "Mutualis App",
          style: TextStyle(color: Theme.of(context).hoverColor),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
            icon: const Icon(
              Icons.blur_on,
              size: 30,
            ),
            color: Colors.black,
            onPressed: () => controller.openDrawer(),
          ),
        ),
        /*leading: Icon(
        Icons.short_text,
        size: 30,
        color: Colors.black,

      ),*/
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(13)),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
                child: Image.asset("assets/user.png", fit: BoxFit.fill),
              ),
            ),
          ),
          const Icon(
            IconlyLight.notification,
            size: 30,
            color: kPrimaryColor,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:   [
           const UserCard(),
            Seprator(title: "Categories",onPressed: (){},),
            const CategoryCard()
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: const [
          Text("Hello,"),
       SizedBox(
         height: 5,
       ),
       Text(
         "Ahmed Mohamed",
         style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
       ),
       ],
      ),
    );
  }
}
