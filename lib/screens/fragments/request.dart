import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newchat/components/friend_row_widget.dart';
import 'package:newchat/controller/home_controller.dart';
import 'package:newchat/models/friends_model.dart';
import 'package:newchat/models/request_model.dart';
import 'package:newchat/screens/view_sent_request.dart';
import 'package:newchat/utils/constants.dart';

import '../../utils/mythems.dart';

class RequestFragment extends StatefulWidget {
  const RequestFragment({Key? key}) : super(key: key);

  @override
  State<RequestFragment> createState() => _RequestFragmentState();
}

class _RequestFragmentState extends State<RequestFragment> {
  final HomeController _controller = HomeController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const ViewSentRequest()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyThem.primary,
            ),
            child: const Center(
              child: Text(
                'View sent request',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: StreamBuilder(
            stream: _controller.db
                .collection(AppConstant.request)
                .where('receiver',
                    isEqualTo: _controller.auth.currentUser?.email)
                .where('accepted', isEqualTo: false)
                .snapshots(),
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError || !snap.hasData) {
                return const Center(
                  child: Text("No Friend Request Found"),
                );
              }
              return ListView.builder(
                itemCount: snap.data?.size ?? 0,
                itemBuilder: (con, index) {
                  QueryDocumentSnapshot<Map<String, dynamic>>? data =
                      snap.data?.docs[index];

                  RequestModel requestModel =
                      RequestModel.fromMap(data?.data() ?? {});
                  final sender = requestModel.sender ?? "";
                  final String id = requestModel.id ?? "";
                  return FutureBuilder(
                    future: _controller.db
                        .collection(AppConstant.user)
                        .where('email', isEqualTo: sender)
                        .get(),
                    builder: (c, futureSnap) {
                      if (futureSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (futureSnap.hasError || !futureSnap.hasData) {
                        return const Center(
                          child: Text('No Requests'),
                        );
                      }
                      var user = futureSnap.data?.docs.firstWhereOrNull(
                          (element) => element.get('email') == sender);

                      return FriendRowWidget(
                        isRequest: true,
                        name: user?.get('name'),
                        email: sender,
                        onReject: () async {
                          bool result = await _controller.removeRequest(sender);
                          if (result) {
                            Get.snackbar("Friend Removed",
                                "Friend request removed from $sender",
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar("Error",
                                "Friend request remove error from $sender",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        onAccept: () async {
                          bool result = await _controller.acceptRequest(id);
                          if (result) {
                            Get.snackbar("Request Accepted",
                                "Friend request accepted from $sender",
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar("Error",
                                "Friend request accepted Error from $sender",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
