import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:jbuti_app/app/components/AppDrawer.dart';
import 'package:jbuti_app/app/components/category_card.dart';
import 'package:jbuti_app/app/components/seprator_card.dart';
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/modules/category/controllers/category_controller.dart';
import 'package:jbuti_app/app/modules/category/views/categories_view.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

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
          children: [
            const UserCard(),
            GetBuilder<CategoryController>(
              builder: (cont) {
                return Visibility(
                  visible:cont.categories.isNotEmpty ,
                  child: Seprator(
                    title: "Categories",
                    onPressed: () =>Get.to(()=>const CategoriesView()),
                  ),
                );
              }
            ),
            SizedBox(
              width: double.infinity,
              height: Get.height / 4,
              child: GetBuilder<CategoryController>(
                builder: (cont) {
                  if (cont.isLoadingCategory) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (cont.categories.isEmpty) {
                    return const Center(
                      child: Text("No Categories"),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cont.categories.length,
                      itemBuilder: (context, index) =>  CategoryCard(category: cont.categories[index]),
                    );
                  }
                },
              ),
            ),
            GetBuilder<CategoryController>(
              builder: (cont) {
                return Visibility(
                  visible:cont.categories.isNotEmpty ,
                  child: Seprator(
                    title: "Doctors",
                    onPressed: () =>Get.to(()=>const CategoriesView()),
                  ),
                );
              }
            ),
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
