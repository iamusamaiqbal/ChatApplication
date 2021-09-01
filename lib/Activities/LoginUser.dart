import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebaseapp/Activities/Home.dart';
import 'package:flutter_firebaseapp/Activities/RegisterUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUser extends StatefulWidget {

  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _uemail = TextEditingController();
  final _upassword = TextEditingController();
  final _error = TextEditingController();

  Future<User> _loginUser(String email,String password) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;

  }on FirebaseAuthException catch (e) {
      print(e);
      return null;
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
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: new BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 40,
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
                      if(_uemail.text.isNotEmpty && _upassword.text.isNotEmpty){

                        User user = await _loginUser(_uemail.text, _upassword.text);

                        _uemail.clear();
                        _upassword.clear();

                        if(user != null){
                          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Home()));
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>RegisterUser()));
                        }
                      }else{
                        setState(() {
                          _error.text = "All inputs are required";
                        });
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple,
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
                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>RegisterUser()));
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                        child: Text("Click here if you don't have"),
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
