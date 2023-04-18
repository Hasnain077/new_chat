import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newchat/controller/home_controller.dart';
import 'package:newchat/models/user_model.dart';
import 'package:newchat/utils/constants.dart';
import 'package:newchat/utils/mythems.dart';

class ChatScreen extends StatefulWidget {
  final String? chatName;
  final String? chatImage;
  final UserModel friend;

  const ChatScreen({
    Key? key,
    this.chatName,
    this.chatImage,
    required this.friend,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final HomeController _homeController = HomeController.instance;
  late CollectionReference collection;
  bool isSeen = false;
  @override
  void initState() {
    _homeController.setChattingTo(widget.friend.email ?? "");
    _homeController.updateIsseen(widget.friend.uid ?? "");
    collection = _homeController.db.collection(AppConstant.chats);

    super.initState();
  }

  @override
  void dispose() {
    _homeController.deleteChattingTo();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: MyThem.primary,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(
                      Icons.adaptive.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      radius: 15.0,
                      backgroundImage: ExactAssetImage('assets/jpg/spider.jpg'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              Text(
                widget.friend.name ?? "",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
              color: Colors.white,
              itemBuilder: (_) {
                return [];
              })
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: StreamBuilder(
                    stream: collection
                        .doc(_homeController.currentUser?.uid)
                        .collection(widget.friend.uid ?? "")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (context, snap) {
                      if (snap.hasData) {}

                      return ListView.builder(

                        reverse: true,
                        shrinkWrap: true,
                        itemCount: snap.data?.docs.length ?? 0,
                        itemBuilder: (_, index) {
                          Map<String, dynamic> data =
                              snap.data?.docs[index].data() ?? {};
                          _homeController.updateIsseen(widget.friend.uid ?? "");
                          String msg = data["msg"] ?? "";
                          bool isSender = data["issender"] ?? false;
                          bool isSeen = data["isseen"] ?? false;

                          return BubbleNormal(
                            text: msg,
                            bubbleRadius: 20,
                            textStyle: TextStyle(
                                color: isSender ? Colors.white : null),
                            seen: isSender ? isSeen : false,
                            isSender: isSender,
                            color: isSender ? Colors.red : Colors.grey.shade300,
                            tail: true,
                            sent: isSender,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      controller: _textEditingController,
                      onTap: () {},
                      decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.attach_file_rounded,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          hintText: "Message",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          filled: true,
                          fillColor: Colors.white),
                      showCursor: true,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: MyThem.primary),
                    child: GestureDetector(
                      onTap: () async {
                        await _homeController.sendMessage(
                            friendUid: widget.friend.uid ?? "",
                            msg: _textEditingController.text.trim());
                        _textEditingController.text = "";
                      },
                      child: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
