import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newchat/utils/mythems.dart';

class ChatScreen extends StatefulWidget {
  final String? chatName;
  final String? chatImage;

  const ChatScreen({
    Key? key,
    this.chatName,
    this.chatImage,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> chatList = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyThem.primary,
        leading: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
            ),
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Image.asset(
                "assets/png/chatlogo.png",
                height: 30,
              ),
            ),
          ],
        ),
        title: Text(
          widget.chatName.toString(),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Container(
            color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (_, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyThem.chat),
                              child: Text(chatList[index]),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onEditingComplete: () {
                          setState(() {
                            chatList.add(_textEditingController.text);
                            _textEditingController.text = "";
                          });
                        },
                        controller: _textEditingController,
                        onTap: () {
                          print('tap');
                        },
                        maxLines: null,
                        decoration: InputDecoration(
                            prefixIcon: GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.emoji_emotions_outlined),
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
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.attach_file_rounded),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: MyThem.primary),
                      child: GestureDetector(
                        onLongPress: () {},
                        onTap: () {
                          setState(() {
                            chatList.add(_textEditingController.text);
                            _textEditingController.text = "";
                          });
                        },
                        child: Icon(Icons.send_outlined),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
