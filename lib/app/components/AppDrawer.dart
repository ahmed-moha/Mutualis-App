import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:jbuti_app/app/constants.dart';

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
              
              text: 'Accueil',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, "/HomePage")
          ),
          _createDrawerItem(
              icon:IconlyLight.calendar,
              text: 'Rendez-vous',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, "/HomePage")),

          _createDrawerItem(
              icon:IconlyLight.calendar,
              text: 'Mon dossier',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, "/HomePage")),
          _createDrawerItem(
              icon: Icons.directions_car_sharp,
              text: 'Ambulances',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, "/HomePage")),
          const Divider(),
          _createDrawerItem(
              icon: IconlyLight.info_circle,
              text: 'Informations',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, "/actualities")),
          const Divider(),
          _createDrawerItem(icon: IconlyBroken.logout,
            text: 'Déconnexion',
            onTap: () => Navigator.pushReplacementNamed(context, "/login")),
          /*_createDrawerItem(icon: Icons.face, text: 'Authors'),
          _createDrawerItem(icon: Icons.account_box, text: 'Flutter Documentation'),
          _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),*/
          const Divider(),
          _createDrawerItem(icon: Icons.info, text: 'A propos',
          onTap: () => Navigator.pushReplacementNamed(context, "/about")
          ),
          ListTile(
            title: const Text('0.0.1'),
            onTap: () {

            },
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
                image: AssetImage('assets/images/drawer_header_background.png')
            )
        ),
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
      {required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon,color: kPrimaryColor),
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