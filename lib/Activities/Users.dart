import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../UserClass.dart';
import 'Inbox.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List<UserClass> users = [];
  List<String> chatusers = [];
  FirebaseAuth auth = FirebaseAuth.instance;


  // _getUserList() will return unknown users or current user did not have chat

  Future<List> _getUserList() async {
    // list of friends

    final ref2 = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child("${auth.currentUser.uid}/Chats")
        .once()
        .then((DataSnapshot datasnap) {
      chatusers.clear();
      Map<dynamic, dynamic> values = datasnap.value;
      values.forEach((key, values) {
        chatusers.add(
          values['id'],
        );
        setState(() {});
      });
    });

    //List of remaining users
    final ref = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .orderByChild('displayname');
    ref.once().then((DataSnapshot datasnap) {
      users.clear();

      Map<dynamic, dynamic> values = datasnap.value;

      values.forEach((key, values) {
        if (chatusers.contains(values['id'])){
        }
        else{
          users.add(new UserClass(
            id: values['id'],
            name: values['displayname'],
          ));
          setState(() {});
        }
      });
    });

    return users;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserList();
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
          future: _getUserList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<UserClass> data = snapshot.data;
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
                          data[index].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right, size: 30.0),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Inbox(
                                        reciever: data[index],
                                        chatid: null,
                                      )));
                        },
                      ),
                    );
                  },
                  itemCount: data.length);
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
