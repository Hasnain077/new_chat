import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:newchat/utils/constants.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser;

  Future<bool> sendFriendRequests(String email) async {
    var data = await db
        .collection(AppConstant.user)
        .where('email', isEqualTo: email)
        .get();
    if (data.size <= 0) {
      Get.snackbar("Request not sent", "Friend Request Already Sent",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    String? myEmail = auth.currentUser?.email;
    var requestExists = await db
        .collection(AppConstant.request)
        .where('sender', isEqualTo: myEmail)
        .where('receiver', isEqualTo: email)
        .get();
    if (requestExists.size >= 1) {
      Get.snackbar("Request not sent", "Friend Request Already Sent",
          snackPosition: SnackPosition.BOTTOM);

      return false;
    }
    requestExists = await db
        .collection(AppConstant.request)
        .where('receiver', isEqualTo: myEmail)
        .where('sender', isEqualTo: email)
        .get();
    if (requestExists.size >= 1) {
      Get.snackbar("Request not sent", "Friend Request Already Pending",
          snackPosition: SnackPosition.BOTTOM);

      return false;
    }
    await db.collection(AppConstant.request).add(
      {
        "sender": myEmail,
        "receiver": email,
        "accepted": false,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
    return true;
  }

  Future<bool> acceptRequest(String id) async {
    try {
      DocumentReference<Map<String, dynamic>> ref =
          db.collection(AppConstant.request).doc(id);
      await ref.update({'accepted': true});
      var docData = await ref.get();
      String sender = docData['sender'];
      String receiver = docData['receiver'];

      var currentTime = DateTime.now().millisecondsSinceEpoch;
      await db.collection(AppConstant.friends).add({
        'email': receiver,
        'friend': sender,
        'timestamp': currentTime,
        'isBlocked': false,
      });
      await db.collection(AppConstant.friends).add({
        'email': sender,
        'friend': receiver,
        'timestamp': currentTime,
        'isBlocked': false,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeRequest(String email,
      {bool isSent = false, bool isFriend = false}) async {
    String myEmail = auth.currentUser?.email ?? "";

    CollectionReference reference =
        db.collection(isFriend ? AppConstant.friends : AppConstant.request);
    QuerySnapshot<Object?> dataList;
    if (isFriend) {
      dataList = await reference
          .where('email', isEqualTo: myEmail)
          .where('friend', isEqualTo: email)
          .get();
    } else {
      dataList = await reference
          .where('sender', isEqualTo: isSent ? myEmail : email)
          .where('receiver', isEqualTo: isSent ? email : myEmail)
          .get();
    }
    if (dataList.docs.isNotEmpty) {
      var doc = dataList.docs.first;
      String uid = doc.id;
      await reference.doc(uid).delete();
      return true;
    }
    return false;
  }

  Future<void> setChattingTo(String email) async {
    await db.collection(AppConstant.chattingWith).doc(currentUser?.uid).set({
      'friend': email,
    }).catchError((e) => printError());
  }

  Future<void> deleteChattingTo() async {
    await db
        .collection(AppConstant.chattingWith)
        .doc(currentUser?.uid)
        .delete();
  }

  // this function used to send msg
  Future<void> sendMessage(
      {required String friendUid, required String msg}) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    await storeMsgData(friendUid, msg, timeStamp, true);
    await storeMsgData(friendUid, msg, timeStamp, false);
  }

  //common function to store msg data
  Future<void> storeMsgData(String uid, String msg, int timeStamp,
      [bool isSender = true, bool isSeen = false]) async {
    await db
        .collection(AppConstant.chats)
        .doc(isSender ? currentUser?.uid ?? "" : uid)
        .collection(isSender ? uid : currentUser?.uid ?? "")
        .add({
      'msg': msg,
      'issender': isSender,
      'timestamp': timeStamp,
      'isseen': isSeen,
    });
    // function is used to store chat screen
    await db
        .collection(AppConstant.chats)
        .doc(isSender ? currentUser?.uid ?? "" : uid)
        .collection("ChatList")
        .doc(isSender ? uid ?? "" : currentUser?.uid)
        .set({'timestamp': timeStamp, 'is_deleted': false});
  }

  //this function is used to update the [isseen] data
  Future<void> updateIsseen(String uid) async {
    var ref = db
        .collection(AppConstant.chats)
        .doc(uid)
        .collection(currentUser?.uid ?? "");

    QuerySnapshot snaps = await ref.where('isseen', isNotEqualTo: true).get();
    for (QueryDocumentSnapshot doc in snaps.docs) {
      await ref
          .doc(doc.id)
          .update({'isseen': true})
          .then((value) => print("updated"))
          .catchError((e) => print("error"));
    }
  }
}
