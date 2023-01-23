import 'package:get/get.dart';
import 'package:jbuti_app/app/components/utils.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'enum/user_state.dart';


class UserStateMethods {
 

  void setUserState({required String userId, required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);
    FirebaseFirestore.instance.collection("Users").doc(userId).update({
      "state": stateNum,
      "lastSeen": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Stream<DocumentSnapshot> getUserStream({required String uid}) =>
      FirebaseFirestore.instance.collection("Users").doc(uid).snapshots();

 
  
  logoutuser(){
    Get.find<UserController>().logOut();
  }

  // Future<Null> logoutuser(BuildContext context) async {
  
  //   setUserState(
  //       userId: preferences.getString("uid"), userState: UserState.Offline);
  //   await FirebaseAuth.instance.signOut();
  //   await preferences.clear();

  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => Authenticate()),
  //       (route) => false);
  // }
}
