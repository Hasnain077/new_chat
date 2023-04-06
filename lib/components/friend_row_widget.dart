import 'package:flutter/material.dart';
import 'package:newchat/utils/mythems.dart';

class FriendRowWidget extends StatelessWidget {
  final String? name;
  final String? email;

  final bool isRequest;
  final void Function()? onAccept;
  final void Function()? onReject;
  final void Function()? onPush;
  const FriendRowWidget({
    super.key,
    this.name,
    this.email,
    this.isRequest = false,
    this.onAccept,
    this.onReject,
    this.onPush,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPush,
      leading: Image.asset(
        "assets/png/chatlogo.png",
        height: 50,
      ),
      title: Text(name ?? "", style: const TextStyle(color: Colors.black)),
      subtitle: Text(email ?? ""),
      trailing: SizedBox(
        height: 70,
        width: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: isRequest,
              child: GestureDetector(
                onTap: onAccept,
                child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: MyThem.primary.withOpacity(0.2),
                        border: Border.all(color: Colors.green, width: 0.5)),
                    child: Icon(
                      Icons.check,
                      color: MyThem.primary.withOpacity(0.2),
                    )),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: onReject,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.red.withOpacity(0.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
