import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../../components/friend_row_widget.dart';
import '../../controller/home_controller.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/mythems.dart';
import '../chat_screen.dart';

class ChatsFragment extends StatefulWidget {
  const ChatsFragment({Key? key}) : super(key: key);

  @override
  State<ChatsFragment> createState() => _ChatsFragmentState();
}

class _ChatsFragmentState extends State<ChatsFragment> {
  final HomeController _controller = HomeController.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.db
          .collection(AppConstant.chats)
          .doc(_controller.currentUser?.uid)
          .collection("ChatList")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snap.hasError || !snap.hasData) {
          return const Text("Error");
        }

        if (snap.data == null) {
          return const Text("Error");
        }

        return ListView.builder(
          itemCount: snap.data?.size ?? 0,
          itemBuilder: (con, index) {
            QueryDocumentSnapshot<Map<String, dynamic>>? data =
                snap.data?.docs[index];

            return FutureBuilder(
              future: _controller.db
                  .collection(AppConstant.user)
                  .doc(data?.id)
                  .get(),
              builder: (c, futureSnap) {
                var user = futureSnap.data?.data();
                UserModel userModel = UserModel.fromMap(user ?? {});
                String name = userModel.name ?? "";
                String email = userModel.email ?? "";
                String uid = userModel.uid ?? "";
                bool isSeen = true;
                return FriendRowWidget(
                  name: name,
                  email: email,
                  onPush: () async {
                    await {};
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChatScreen(friend: userModel)),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
