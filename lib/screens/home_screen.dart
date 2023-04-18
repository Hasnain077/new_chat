import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:newchat/controller/home_controller.dart';
import 'package:newchat/screens/change_password.dart';
import 'package:newchat/screens/fragments/friends.dart';
import 'package:newchat/screens/fragments/request.dart';
import 'package:newchat/screens/login_screen.dart';
import 'package:newchat/utils/mythems.dart';

import 'fragments/chats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyThem.primary,
        title: Text(
          "let's chat",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded, color: Colors.white),
          ),
          PopupMenuButton(
            icon: Icon(Icons.adaptive.more),
            onSelected: (index) {
              if (index == 0) {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('Logout?'),
                      content: Text('Do you want to Logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (route) => false);
                          },
                          child: const Text('Yes'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('No'),
                        ),
                      ],
                    );
                  },
                );
              }

              if (index == 1) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text('Change Password?'),
                        content: const Text('Do you want to Change Password?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChangePassword(),
                                ),
                              );
                            },
                            child: const Text('Yes'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                        ],
                      );
                    });
              }
            },
            itemBuilder: (_) {
              return [
                const PopupMenuItem(
                  enabled: true,
                  value: 1,
                  child: Text("Change Password"),
                ),
                const PopupMenuItem(
                  enabled: true,
                  value: 0,
                  child: Text("Logout"),
                ),
              ];
            },
            padding: EdgeInsets.zero,
            color: Colors.white,
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: MyThem.primary),
                child: TabBar(
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  controller: _tabController,
                  onTap: (index) {
                    _pageController.animateToPage(index,
                        duration: Duration(
                          milliseconds: 200,
                        ),
                        curve: Curves.linear);
                  },
                  tabs: const [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Friends"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Chats"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Requests"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  onPageChanged: (index) {
                    _tabController.animateTo(index);
                  },
                  controller: _pageController,
                  children: const [
                    FriendsFragment(),
                    ChatsFragment(),
                    RequestFragment(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
