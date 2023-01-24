import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:jbuti_app/app/modules/home/controllers/home_controller.dart';

import '../../../../generated/locales.g.dart';
import '../../../components/AppDrawer.dart';
import '../../../components/category_card.dart';
import '../../../components/seprator_card.dart';
import '../../../constants.dart';
import '../../../data/doctor_model.dart';
import '../../../general.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/views/categories_view.dart';
import '../../user/controllers/user_controller.dart';
import 'doctor_detail_page.dart';
import 'home_view.dart';

class Phome extends StatelessWidget {
  const Phome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
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
                child: GetBuilder<UserController>(builder: (cont) {
                  return Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: ExtendedImage.network(
                        cont.user.photoUrl ?? defaultPhotoUrl,
                        fit: BoxFit.fill),
                  );
                }),
              ),
            ),
            // const Icon(
            //   IconlyLight.notification,
            //   size: 30,
            //   color: kPrimaryColor,
            // ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserCard(),
              GetBuilder<CategoryController>(builder: (cont) {
                return Visibility(
                  visible: cont.categories.isNotEmpty,
                  child: Seprator(
                    title:LocaleKeys.categories.tr,
                    onPressed: () => Get.to(() => const CategoriesView()),
                  ),
                );
              }),
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
                        itemBuilder: (context, index) =>
                            CategoryCard(category: cont.categories[index]),
                      );
                    }
                  },
                ),
              ),
              GetBuilder<CategoryController>(builder: (cont) {
                return Visibility(
                  visible: cont.categories.isNotEmpty,
                  child: Seprator(
                    title:LocaleKeys.doctors.tr,
                    onPressed: () => Get.to(() => const CategoriesView()),
                  ),
                );
              }),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("isDoctor", isEqualTo: true)
                    //.limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(kPrimaryColor)),
                    );
                  } else {
                    // doctorDataList = snapshot.data.documents;
                    return ListView.builder(
                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, int index) {
                        //log(snapshot.data!.docs[index].data().toString());
                        var data =
                            jsonEncode(snapshot.data!.docs[index].data());
                        final decodedData = jsonDecode(data);
                        DoctorModel doctor = DoctorModel.fromJson(decodedData);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailPage(
                                doctor: doctor,
                              );
                            }));
                          },
                          child: doctorTile(doctor, context),
                        );
                      },
                      itemCount: snapshot.data?.docs.length,
                      //reverse: true,
                      //controller: listScrollController,
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

  Widget doctorTile(DoctorModel doctor, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: Get.isDarkMode?[]:[
          BoxShadow(
            offset: const Offset(4, 4),
            blurRadius: 10,
            color: Colors.grey.withOpacity(.2),
          ),
          BoxShadow(
            offset: const Offset(-3, 0),
            blurRadius: 15,
            color: Colors.grey.withOpacity(.1),
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: General().randomColor(context),
              ),
              child: ExtendedImage.network(
                doctor.photoUrl ?? defaultPhotoUrl,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            doctor.name ?? "",
            style:  TextStyle(
                fontSize: 16 * 1.2, fontWeight: FontWeight.bold,color: Theme.of(context).hoverColor),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              doctor.type ?? "",
              style:  TextStyle(
                  fontSize: 12 * 1.2,
                 color: Theme.of(context).hoverColor,
                  fontWeight: FontWeight.w300),
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      //Navigator.pushNamed(context, "/DetailPage", arguments: model);
    );
  }
}
