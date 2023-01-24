import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:jbuti_app/app/constants.dart';
import 'package:jbuti_app/app/modules/ambulances/views/about.dart';
import 'package:jbuti_app/app/modules/ambulances/views/appointments_list.dart';
import 'package:jbuti_app/app/modules/home/controllers/home_controller.dart';
import 'package:jbuti_app/app/routes/app_pages.dart';
import 'package:jbuti_app/generated/locales.g.dart';

import '../modules/ambulances/views/dossier.dart';
import '../modules/ambulances/views/informations.dart';
import '../modules/user/controllers/user_controller.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: IconlyLight.home,
              text: LocaleKeys.home.tr,
              onTap: () => Get.back()),
          _createDrawerItem(
            icon: IconlyLight.calendar,
            text: LocaleKeys.my_appointments.tr,
            onTap: () => Get.to(
              () => MyAppointmentsPage(),
            ),
          ),

          _createDrawerItem(
              icon: IconlyLight.calendar,
              text: LocaleKeys.my_files.tr,
              onTap: () => Get.to(() => DossierPatientPage())),
          _createDrawerItem(
              icon: Icons.directions_car_sharp,
              text: LocaleKeys.ambulances.tr,
              onTap: () => Get.toNamed(Routes.AMBULANCES)),
          const Divider(),
          _createDrawerItem(
              icon: IconlyLight.info_circle,
              text: LocaleKeys.information.tr,
              onTap: () => Get.to(() => InformationsPage())),
          GetBuilder<HomeController>(
            builder: (cont) {
              return ListTile(
                title: Row(
                  children: const <Widget>[
                    Icon(
                      Icons.dark_mode_outlined,
                      color: kPrimaryColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Dark Mode"),
                    )
                  ],
                ),
                onTap: (){},
                trailing: Switch(
                  activeColor: kPrimaryColor,
                  onChanged:cont.updateDarkMode,
                  value: cont.isDarkMode,
                ),
              );
            }
          ),
          const Divider(),
          // _createDrawerItem(icon: IconlyBroken.logout,
          //   text: 'Déconnexion',
          //   onTap: () => Get.toNamed(Routes.USER),),
          _createDrawerItem(
              icon: Icons.language,
              text: LocaleKeys.languages.tr,
              onTap: () => Get.toNamed(Routes.LANGUAGES)),
          GetBuilder<UserController>(builder: (cont) {
            return _createDrawerItem(
                icon: IconlyLight.logout,
                text: LocaleKeys.log_out.tr,
                onTap: () => cont.logOut());
          }),

          /*_createDrawerItem(icon: Icons.face, text: 'Authors'),
          _createDrawerItem(icon: Icons.account_box, text: 'Flutter Documentation'),
          _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),*/
          const Divider(),
          _createDrawerItem(
              icon: Icons.info,
              text: LocaleKeys.about.tr,
              onTap: () => Get.to(() => AboutPage())),
          ListTile(
            title: const Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                fit: BoxFit.fill,
                image:
                    AssetImage('assets/images/drawer_header_background.png'))),
        child: Stack(children: const <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Mutualis App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: kPrimaryColor),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
