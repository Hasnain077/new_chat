import 'package:flutter/material.dart';

import '../../utils/mythems.dart';

class RequestFragment extends StatefulWidget {
  const RequestFragment({Key? key}) : super(key: key);

  @override
  State<RequestFragment> createState() => _RequestFragmentState();
}

class _RequestFragmentState extends State<RequestFragment> {
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
          Icons.notification_add_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
