import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newchat/controller/home_controller.dart';
import 'package:newchat/utils/constants.dart';
import 'package:newchat/utils/mythems.dart';

class FriendsFragment extends StatefulWidget {
  const FriendsFragment({Key? key}) : super(key: key);

  @override
  State<FriendsFragment> createState() => _FriendsFragmentState();
}

class _FriendsFragmentState extends State<FriendsFragment> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HomeController _homeController = HomeController.instance;
  final GlobalKey<FormState> _dialogFormKey = GlobalKey();
  final TextEditingController _friendEmailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text("Add Friend"),
                    content: SizedBox(
                      // height: double.maxFinite,
                      child: Form(
                        key: _dialogFormKey,
                        child: TextFormField(
                          controller: _friendEmailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            if (!value.isEmail) {
                              return "Invalid Email";
                            }
                            if (_auth.currentUser?.email == value) {
                              return "Cannot send request to own email";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          if (!_dialogFormKey.currentState!.validate()) {
                            return;
                          }
                          String email = _friendEmailController.text.trim();
                          bool result =
                              await _homeController.sendFriendRequests(email);
                          if (!result) {
                            Get.snackbar("No Friend Exists", "Email not exists",
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar(
                                "Request Sent", "Friend request sent to $email",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                          if (_.mounted) Navigator.pop(_);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyThem.primary.withOpacity(0.7),
                        ),
                        child: const Text(
                          "Send Request",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyThem.primary,
            ),
            child: const Text(
              "Add Friend",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: _db
                .collection(AppConstant.friends)
                .doc(_auth.currentUser?.uid)
                .snapshots(),
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {}
              if (!snap.hasData) {}
              if (snap.data == null) {
                return const Text("Error");
              }
              DocumentSnapshot<Map<String, dynamic>> data = snap.data!;
              return Container();
            },
          ),
        )
      ],
    );
  }
}
