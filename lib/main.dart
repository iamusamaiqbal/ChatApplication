import 'package:flutter/material.dart';
import 'package:flutter_firebaseapp/Activities/LoginUser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        fontFamily: 'OpenSans'
      ),
      home: LoginUser(),
    );
  }
}



