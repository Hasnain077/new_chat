import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/mythems.dart';

class ChatsFragment extends StatefulWidget {
  const ChatsFragment({Key? key}) : super(key: key);

  @override
  State<ChatsFragment> createState() => _ChatsFragmentState();
}

class _ChatsFragmentState extends State<ChatsFragment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          backgroundColor: MyThem.primary,
        ),
        onPressed: () async {},
        child: Icon(
          Icons.chat_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
