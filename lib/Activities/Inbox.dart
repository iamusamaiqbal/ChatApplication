import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebaseapp/MessageClass.dart';

import 'package:flutter_firebaseapp/UserClass.dart';

class Inbox extends StatefulWidget {
  final FirebaseApp app;
  final String chatid;
  final UserClass reciever;

  Inbox({this.reciever, this.app, this.chatid});

  @override
  _InboxState createState() => _InboxState(this.reciever, this.chatid);
}

class _InboxState extends State<Inbox> {
  _InboxState(this.reciever, this.chatid);

  final String chatid;
  final UserClass reciever;
  final _msg = TextEditingController();
  final auth = FirebaseAuth.instance;

  List<MessageClass> msgs = [];

  Future<List<MessageClass>> _getMsgList() async {
    if (chatid != null) {
      final ref = FirebaseDatabase.instance
          .reference()
          .child("Chats")
          .child("${chatid}");
      ref.once().then((DataSnapshot datasnap) {
        msgs.clear();

        Map<dynamic, dynamic> values = datasnap.value;
        values.forEach((key, values) {
          msgs.add(new MessageClass(
              senderid: values["senderid"],
              recieverid: values["recieverid"],
              msg: values["msg"]));
          setState(() {});
        });
      });
      return msgs;
    } else {
      setState(() {});
      return null;
    }
  }

  String _newChat(
    String recieverid,
    String rName,
    String senderid,
    String sName,
  ) {
    final ref = FirebaseDatabase.instance.reference().child("Chats");
    final newChatKey = ref.push().key;
    ref.child(newChatKey).set({
      'id1': senderid,
      'id2': recieverid,
    });

    final userref = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child("$senderid/Chats");
    userref
        .child(recieverid)
        .set({'chatid': newChatKey, 'username': rName, 'id': recieverid});

    final userref2 = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child("$recieverid/Chats");
    userref2
        .child(senderid)
        .set({'chatid': newChatKey, 'username': sName, 'id': senderid});

    setState(() {});
  }

  void _sentMsg(String recieverid, String rName, String senderid, String sName,
      String msg) {
    if (chatid == null) {
      _newChat(recieverid, rName, senderid, sName);
    } else {
      final ref =
          FirebaseDatabase.instance.reference().child("Chats").child(chatid);
      final newMsgKey = ref.push().key;

      ref.child(newMsgKey).set({
        'senderid': senderid,
        'recieverid': recieverid,
        'msg': msg,
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          margin: EdgeInsets.only(left: 3, right: 3, bottom: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.purple
          ),
        ),
        title: Text(reciever.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(3),
              height: double.maxFinite,
              width: double.infinity,
              margin: EdgeInsets.all(3),
              decoration: new BoxDecoration(
                color: Colors.white,
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FutureBuilder(
                future: _getMsgList(),
                builder: (context, snapshot) {
                  List<MessageClass> data = snapshot.data;
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        if (data[index].senderid == auth.currentUser.uid) {
                          return BubbleNormal(
                            text: data[index].msg,
                            isSender: true,
                            color: Color(0xD8E8E8EE),
                            tail: true,
                            sent: true,
                            textStyle: TextStyle(
                              fontSize: 20,
                            ),
                          );
                        } else {
                          return BubbleNormal(
                              text: data[index].msg,
                              isSender: false,
                              color: Color(0xFF2196F3),
                              tail: true,
                              textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ));
                        }
                      },
                      itemCount: data.length,
                    );
                  } else if (snapshot == null) {
                    return Center(
                      child: Container(
                        child: Text('No Message yet'),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: TextField(
              controller: _msg,
              cursorColor: Colors.purpleAccent,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _sentMsg(reciever.id, reciever.name, auth.currentUser.uid,
                          auth.currentUser.displayName, _msg.text);
                      _msg.clear();
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.purple,
                    ),
                  ),
                  hintText: "Message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
