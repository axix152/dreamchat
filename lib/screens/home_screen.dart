import 'package:dreamchat/const.dart';
import 'package:dreamchat/features/auth/screens/number_screen.dart';
import 'package:dreamchat/screens/Tab_bar_items/call_tab.dart';
import 'package:dreamchat/screens/Tab_bar_items/chat_tap.dart';
import 'package:dreamchat/screens/Tab_bar_items/groups_tab.dart';
import 'package:dreamchat/screens/Tab_bar_items/status_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "HomeScreen";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 1,
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: kappColor,
              title: const Text("Hi jesscia"),
              centerTitle: false,
              leading: const Padding(
                  padding: EdgeInsets.all(7),
                  child: CircleAvatar(
                    backgroundColor: kscaffoldGB,
                    radius: 20,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: kappColor,
                    ),
                  )),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut().whenComplete(() {
                      Navigator.pushNamed(context, NumberScreen.routeName);
                    });
                  },
                  child: const Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.more_vert,
                  size: 30,
                  color: Colors.white,
                )
              ],
              bottom: TabBar(
                indicatorColor: Colors.white,
                labelStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                tabs: const [
                  Tab(
                    text: "Chat",
                  ),
                  Tab(
                    text: "Group",
                  ),
                  Tab(
                    text: "Status",
                  ),
                  Tab(
                    text: "Calls",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                ChatScreen(),
                const GroupTab(),
                const StatusTab(),
                const CallTab(),
              ],
            )),
      ),
    );
  }
}
