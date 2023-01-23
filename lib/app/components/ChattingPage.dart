import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:jbuti_app/app/components/chat_detail_page_appbar.dart';
import 'package:jbuti_app/app/components/utils.dart';
import 'package:jbuti_app/app/modules/user/controllers/user_controller.dart';

import '../constants.dart';
import 'enum/message_type.dart';
import 'msg_item.dart';

class Chat extends StatelessWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  final String currUserId;
  final String currUserAvatar;
  final String currUserName;

  const Chat({
    Key? key,
    required this.receiverId,
    required this.receiverAvatar,
    required this.receiverName,
    required this.currUserId,
    required this.currUserAvatar,
    required this.currUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailPageAppBar(
        receiverName: receiverName,
        receiverAvatar: receiverAvatar,
        receiverId: receiverId,
        currUserId: currUserId,
        currUserAvatar: currUserAvatar,
        currUserName: currUserName,
      ),
      body: ChatScreen(
        receiverId: receiverId,
        receiverAvatar: receiverAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverAvatar;
  const ChatScreen({
    Key? key,
    required this.receiverId,
    required this.receiverAvatar,
  }) : super(key: key);

  @override
  State createState() => ChatScreenState(
        receiverId: receiverId,
        receiverAvatar: receiverAvatar,
      );
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({
    Key? key,
    required this.receiverId,
    required this.receiverAvatar,
  });
  final String? receiverId;
  final String? receiverAvatar;
  TextEditingController textEditingController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  bool isDisplaySticker = false;
  bool isLoading = false;

  File? imageFile;
  String imageUrl = defaultPhotoUrl;
  var picker = ImagePicker();

  String? chatId;
  String? id;

  String? recieverFcmToken;

  var listMessage = [];

  GlobalKey gifBtnKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);
    isDisplaySticker = false;
    isLoading = false;

    chatId = "";
    readLocal();

    // menu = PopupMenu(items: [
    //   const MenuItem(
    //       title: 'Camera',
    //       image: Icon(
    //         Icons.camera,
    //         color: Colors.white,
    //       )),
    //   const MenuItem(
    //       title: 'Galerie',
    //       image: Icon(
    //         Icons.image,
    //         color: Colors.white,
    //       )),
    //   const MenuItem(
    //       title: 'Sticker',
    //       image: Icon(
    //         Icons.insert_emoticon,
    //         color: Colors.white,
    //       )),
    //   const MenuItem(
    //       title: 'GIF',
    //       image: Icon(
    //         Icons.gif,
    //         color: Colors.white,
    //       )),
    // ], onClickMenu: onClickMenu, onDismiss: onDismiss, maxColumn: 4);
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  // void onClickMenu(MenuItemProvider item) {
  //   switch (item.menuTitle) {
  //     case "Camera":
  //       getImage(isGallery: false);
  //       setState(() {
  //         isDisplaySticker = false;
  //       });
  //       break;

  //     case "Galerie":
  //       getImage(isGallery: true);
  //       setState(() {
  //         isDisplaySticker = false;
  //       });
  //       break;

  //     case "Sticker":
  //       getSticker();
  //       break;

  //     case "GIF":
  //       getGif();
  //       setState(() {
  //         isDisplaySticker = false;
  //       });
  //       break;
  //   }

  //   print('Click menu -> ${item.menuTitle}');
  // }

  void onDismiss() {
    print('Menu is dismiss');
  }

  readLocal() async {
    final user = Get.find<UserController>();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(receiverId)
        .get()
        .then((datasnapshot) {
      // print(datasnapshot.data["name"]);
      // print(datasnapshot.data["fcmToken"]);
      setState(() {
        //recieverFcmToken = datasnapshot.data["fcmToken"];
      });
    });

    id = user.user.uid ?? "";
    if (id.hashCode <= receiverId.hashCode) {
      chatId = '$id-$receiverId';
    } else {
      chatId = '$receiverId-$id';
    }
    setState(() {});
  }

  onFocusChange() {
    // Hide sticker whenever keypad appears
    if (focusNode.hasFocus) {
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //PopupMenu.context = context;
    return WillPopScope(
      onWillPop: onBackPress,
      child: Stack(
        children: [
          Column(
            children: [
              createListMessages(),
              //show stickers
              //(isDisplaySticker ? createStickers() : Container()),
              createInput(),
            ],
          ),
          createLoading(),
        ],
      ),
    );
  }

  createLoading() {
    return Positioned(
      child: isLoading ? const CircularProgressIndicator() : Container(),
    );
  }

  Future<bool> onBackPress() {
    if (isDisplaySticker) {
      setState(() {
        isDisplaySticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  // createStickers() {
  //   return Container(
  //     decoration: const BoxDecoration(
  //         border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
  //         color: Colors.white),
  //     padding: const EdgeInsets.all(5.0),
  //     height: 180.0,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             StickerGif(gifName: "mimi1", onSendMessage: onSendMessage),
  //             StickerGif(gifName: "mimi2", onSendMessage: onSendMessage),
  //             StickerGif(gifName: "mimi3", onSendMessage: onSendMessage),
  //           ],
  //         ),

  //         //ROW 2
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             StickerGif(gifName: "mimi4", onSendMessage: onSendMessage),
  //             StickerGif(gifName: "mimi5", onSendMessage: onSendMessage),
  //             StickerGif(gifName: "mimi6", onSendMessage: onSendMessage),
  //           ],
  //         ),

  //         //ROW 3
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             StickerGif(gifName: "mimi7", onSendMessage: onSendMessage),
  //             StickerGif(gifName: "mimi8", onSendMessage: onSendMessage),
  //             StickerGif(gifName: "mimi9", onSendMessage: onSendMessage),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  createListMessages() {
    return Flexible(
      child: chatId == ""
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(kPrimaryColor)),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(chatId)
                  .collection(chatId ?? "")
                  .orderBy("timestamp", descending: true)
                  // .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(kPrimaryColor)),
                  );
                } else {
                  listMessage = snapshot.data?.docs ?? [];
                  return GetBuilder<UserController>(builder: (cont) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) => MessageItem(
                        index: index,
                        document: snapshot.data?.docs[index],
                        listMessage: listMessage,
                        currUserId: cont.user.uid ?? "",
                        receiverAvatar: receiverAvatar ?? "",
                        context: context,
                        
                      ),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  });
                }
              },
            ),
    );
  }

  // onDeleteMsg(DocumentSnapshot document) {
  //   var docRef = FirebaseFirestore.instance
  //       .collection("messages")
  //       .doc(chatId)
  //       .collection(chatId??"")
  //       .doc(document['timestamp']);
  //   if (document['timestamp'] == listMessage[0]['timestamp']) {
  //     //check type of document if image delete from storage
  //     if (document['type'] == Utils.msgToNum(MessageType.Image)) {
  //       FirebaseStorage.instance
  //           .getReferenceFromUrl(document["content"])
  //           .then((res) {
  //         res.delete().then((value) => print("Deleted"));
  //       });
  //     }
  //     // 𝘛𝘩𝘪𝘴 𝘮𝘦𝘴𝘴𝘢𝘨𝘦 𝘸𝘢𝘴 𝘥𝘦𝘭𝘦𝘵𝘦𝘥
  //     docRef.updateData({
  //       "content": "🚫 Ce message a été supprimé",
  //       "type": Utils.msgToNum(MessageType.Deleted)
  //     });
  //     //change content and type of document
  //     //change from chatlist as well on both sides
  //     Firestore.instance
  //         .collection("Users")
  //         .document(id)
  //         .collection("chatList")
  //         .document(receiverId)
  //         .updateData({
  //       "content": "🚫 Ce message a été supprimé",
  //       "type": Utils.msgToNum(MessageType.Deleted),
  //     });

  //     Firestore.instance
  //         .collection("Users")
  //         .document(receiverId)
  //         .collection("chatList")
  //         .document(id)
  //         .updateData({
  //       "content": "🚫 Ce message a été supprimé",
  //       "type": Utils.msgToNum(MessageType.Deleted),
  //     });
  //   } else {
  //     //else
  //     //check type of document if image delete from storage getref from imageurl
  //     //change content and type of document
  //     if (document['type'] == Utils.msgToNum(MessageType.Image)) {
  //       FirebaseStorage.instance
  //           .getReferenceFromUrl(document["content"])
  //           .then((res) {
  //         res.delete().then((value) => print("Deleted"));
  //       });
  //     }
  //     docRef.updateData({
  //       "content": "🚫 Ce message a été supprimé",
  //       "type": Utils.msgToNum(MessageType.Deleted),
  //     });
  //   }
  // }

  createInput() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Material(
          //   color: Colors.white,
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 1.0),
          //     child: IconButton(
          //       key: gifBtnKey,
          //       icon: const Icon(Icons.attach_file),
          //       color: kPrimaryColor,
          //       onPressed: onAttachmentClick,
          //     ),
          //   ),
          // ),
          Flexible(
            child: Container(
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                decoration: const InputDecoration.collapsed(
                    hintText: "Taper message",
                    hintStyle: TextStyle(color: Colors.grey)),
                focusNode: focusNode,
              ),
            ),
          ),

          //SEND MESSAGE BUTTON
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: kPrimaryColor,
                onPressed: () =>
                    onSendMessage(textEditingController.text, MessageType.Text),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onSendMessage(String contentMsg, MessageType type) {
    setState(() {
      isDisplaySticker = false;
    });

    String currTime = DateTime.now().millisecondsSinceEpoch.toString();

    if (contentMsg != "") {
      String body = type == MessageType.Text
          ? contentMsg
          : type == MessageType.Image
              ? "Image"
              : type == MessageType.Gif
                  ? "GIF"
                  : "Sticker";
      String image = type == MessageType.Image ? contentMsg : "";

      // sendPushNotification(
      //     preferences.getString('name'), recieverFcmToken, body, image);
      textEditingController.clear();

      FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .collection("chatList")
          .doc(receiverId)
          .set({
        "id": receiverId,
        "content": contentMsg,
        "type": Utils.msgToNum(type),
        "timestamp": currTime,
        "showCheck": true
      }, SetOptions(merge: true));

      FirebaseFirestore.instance
          .collection("Users")
          .doc(receiverId)
          .collection("chatList")
          .doc(id)
          .set({
        "id": id,
        "content": contentMsg,
        "type": Utils.msgToNum(type),
        "timestamp": currTime,
        "showCheck": false
      }, SetOptions(merge: true));

      var docRef = FirebaseFirestore.instance
          .collection("messages")
          .doc(chatId)
          .collection(chatId ?? "")
          .doc(currTime);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          docRef,
          {
            "idFrom": id,
            "idTo": receiverId,
            "timestamp": currTime,
            "content": contentMsg,
            "type": Utils.msgToNum(type)
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: const Duration(microseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: "Empty message cannot be sent");
    }
  }

  // void onAttachmentClick() {
  //   menu.show(widgetKey: gifBtnKey);
  // }

  Future getImage({bool isGallery = false}) async {
    final pickedFile = await ImagePicker.platform.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        isLoading = true;
      }
    });

    if (pickedFile != null) {
      uploadImageFile();
    }
  }

  // Future getGif() async {
  //   final gif =
  //       await GiphyPicker.pickGif(context: context, apiKey: GIPHY_API_KEY);

  //   if (gif != null) {
  //     onSendMessage(gif.images.original.url, MessageType.Gif);
  //     print(gif.images.original.url);
  //   }
  // }

  Future uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Chat Images").child(fileName);

    UploadTask storageUploadTask = storageReference.putFile(imageFile!);
    TaskSnapshot storageTaskSnapshot = await storageUploadTask.then((res) {
      return res.ref.getDownloadURL().then((downloadUrl) {
        imageUrl = downloadUrl;
        setState(() {
          isLoading = false;
          onSendMessage(imageUrl, MessageType.Image);
        });

        return Future.value();
      }, onError: (error) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Error: " + error);
      });
    });
  }
}
