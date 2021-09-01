import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebaseapp/ChatClass.dart';
import 'package:flutter_firebaseapp/Activities/Inbox.dart';
import 'package:flutter_firebaseapp/UserClass.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<List> _getChatList() async {
    List<ChatClass> chats = [];

    var cuser = auth.currentUser.uid;

    final uref = await database
        .reference()
        .child("Users")
        .child("${cuser}/Chats")
        .once()
        .then((DataSnapshot datasnap) {
      Map<dynamic, dynamic> values = datasnap.value;
      values.forEach((key, values) {
        chats.add(new ChatClass(
            username: values["username"],
            chatid: values["chatid"],
            id: values["id"]));
        setState(() {});
      });
    });

    return chats;
  }

  initializeApp() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.all(3),
      decoration: new BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder(
        future: _getChatList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ChatClass> data = snapshot.data;
            return ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1.0, color: Colors.black))),
                        child: Icon(
                          Icons.autorenew,
                        ),
                      ),
                      title: Text(
                        data[index].username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right, size: 30.0),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Inbox(
                                      chatid: data[index].chatid,
                                      reciever: UserClass(
                                          id: data[index].id,
                                          name: data[index].username),
                                    )));
                      },
                    ),
                  );
                },
                itemCount: data.length);
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                child: Text('No Chat yet'),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
