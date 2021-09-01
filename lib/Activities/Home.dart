import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebaseapp/Activities/Chats.dart';
import 'package:flutter_firebaseapp/Activities/Users.dart';
import 'package:round_indicator/round_indicator.dart';

class Home extends StatefulWidget {
  final FirebaseApp app;

  Home({this.app});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _textFieldController = TextEditingController();
  String codeDialog;
  String valueText;
  String groupid;
  final database = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          flexibleSpace: Container(
            margin: EdgeInsets.only(left: 3, right: 3, bottom: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.purple,
            ),
          ),
          title: Text(auth.currentUser.displayName),
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(bottom: 5, right: 15, left: 15),
            indicator: RoundTabIndicator(
                isRound: true,
                radius: 2,
                borderSide: BorderSide(width: 4.0),
                insets: EdgeInsets.symmetric(horizontal: 1.0)),
            tabs: [
              Tab(
                text: "Chat",
              ),
              Tab(
                text: "Users",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chats(),
            Users(),
          ],
        ),
      ),
    );
  }
}
