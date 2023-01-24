import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "../views/doctor_screens/settings/AccountSettingsPage.dart" as account;
import 'doctor_screens/Chats.dart';
import 'doctor_screens/UserList.dart';

class DoctorView extends StatefulWidget {
  const DoctorView({
    Key? key,
  }) : super(key: key);
  @override
  _DoctorViewState createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> with WidgetsBindingObserver {
  bool doctorPasswordChanged = true;

  // loadPrefs() async
  // {
  //   preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     if(preferences.getBool("doctorPasswordChanged") != null)
  //       doctorPasswordChanged = preferences.getBool("doctorPasswordChanged");
  //   });
  // }
  @override
  void initState() {
    super.initState();
    // loadPrefs();
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   UserStateMethods()
    //       .setUserState(userId: currentuserid, userState: UserState.Online);
    // });

    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       currentuserid != null
  //           ? UserStateMethods().setUserState(
  //               userId: currentuserid, userState: UserState.Online)
  //           : print("Resumed State");
  //       break;
  //     case AppLifecycleState.inactive:
  //       currentuserid != null
  //           ? UserStateMethods().setUserState(
  //               userId: currentuserid, userState: UserState.Offline)
  //           : print("Inactive State");
  //       break;
  //     case AppLifecycleState.paused:
  //       currentuserid != null
  //           ? UserStateMethods().setUserState(
  //               userId: currentuserid, userState: UserState.Waiting)
  //           : print("Paused State");
  //       break;
  //     case AppLifecycleState.detached:
  //       currentuserid != null
  //           ? UserStateMethods().setUserState(
  //               userId: currentuserid, userState: UserState.Offline)
  //           : print("Detached State");
  //       break;
  //   }
  // }

  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot>? futureSearchResults;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    ChatsPage(),
    //const Text("Chat Page"),
    //const Text("User List"),

    UserList(),
    // const Text("Log Screen"),
    // LogScreen(),
    //  const Text("Settings"),
    account.Settings()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Patients"),
        // BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Profil"),
      ],
    );
  }
}
