import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebaseapp/Activities/LoginUser.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _uname = TextEditingController();
  final _uemail = TextEditingController();
  final _upassword = TextEditingController();
  final _error = TextEditingController();

  Future<bool> _registerUser(String name,String email,String password) async{
    FirebaseAuth auth = FirebaseAuth.instance;

    try {

      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User newuser = auth.currentUser;
      newuser.updateDisplayName(name);


      FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
      DatabaseReference ref = firebaseDatabase.reference().child("Users");

      ref.child(newuser.uid).set({
        'id': newuser.uid,
        'email': newuser.email,
        'displayname': name,
      });

        return true;

    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        _error.text = 'The password provided is too weak.';

          return false;
      } else if (e.code == 'email-already-in-use') {
        _error.text = 'The account already exists for that email.';
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  initializeApp()async{
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: new BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.white70.withOpacity(0.8),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Divider(
                    height: 15,
                  ),
                  TextField(
                    controller: _uname,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                      hintText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  Divider(
                    height: 15,
                  ),
                  TextField(
                    controller: _uemail,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.alternate_email,
                      ),
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  Divider(
                    height: 15,
                  ),
                  TextField(
                    controller: _upassword,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                  ),
                  Divider(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {

                      if(_uemail.text.isNotEmpty && _uname.text.isNotEmpty && _upassword.text.isNotEmpty){

                        bool _flag = await _registerUser(_uname.text, _uemail.text, _upassword.text);

                        if(_flag==true){
                          _error.clear();
                          _uname.clear();
                          _uemail.clear();
                          _upassword.clear();
                          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>LoginUser()));
                        }
                      }else{
                        _error.text = "All inputs are required";
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple
                      ),
                      child: Center(
                        child: Text("Submit",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 15,
                  ),
                  Text(_error.text,style: TextStyle(
                    color: Colors.redAccent,
                  ),),
                  Divider(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=>LoginUser()));
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text("Click here if you already have"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
