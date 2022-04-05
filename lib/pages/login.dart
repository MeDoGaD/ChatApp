import 'package:mychat/Draw/drawer.dart';
import 'package:mychat/helper/helperfunctions.dart';
import 'package:mychat/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/pages/signup.dart';
import 'package:mychat/Widgets/widget.dart';
import 'package:flutter/services.dart';
import 'chat_room.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<Login> {
  TextEditingController _password = new TextEditingController();
  TextEditingController _useremail = new TextEditingController();
  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool isloading = false;
  QuerySnapshot? snapshotUserInfo;
  //FirebaseMessaging firebaseMessaging=new FirebaseMessaging();
  FirebaseFirestore db = FirebaseFirestore.instance;
  signIn() {
    HelperFunctions.saveUserEmail(_useremail.text);
    HelperFunctions.saveUserLoggedIN(true);
    dataBaseMethods.getUserByUseremail(_useremail.text).then((val) {
      snapshotUserInfo = val;
      HelperFunctions.saveUsername(snapshotUserInfo!.docs[0].get("name"));
    });
    setState(() {
      isloading = true;
    });
    authMethods
        .signInWithEmailAndPassword(_useremail.text, _password.text)
        .then((value) async {
      if (value != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ChatRoomsScreen()));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Login failed :( ',
                  style: TextStyle(color: Colors.deepPurple),
                ),
                content:
                    Text('The username or password isn' + "'" + 't correct'),
                actions: <Widget>[
                  FlatButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      onPressed: () {
                        HapticFeedback.vibrate();
                        Navigator.of(context).pop();
                      }),
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double scheight = MediaQuery.of(context).size.height;
    double scwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              height: scheight * 0.3,
              width: scwidth,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: scheight * 0.3,
                          width: scwidth,
                          child: CustomPaint(
                            painter: drawer(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: scheight * 0.14, left: scwidth * 0.25),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: scwidth * 0.2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: scheight * 0.11,
            ),
            Container(
              width: scwidth * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.deepPurple, width: 2)),
              child: Padding(
                padding: EdgeInsets.all(scwidth * 0.02),
                child: TextField(
                  controller: _useremail,
                  style: simpleTextFieldStyle(),
                  decoration: textfield("Email"),
                ),
              ),
            ),
            SizedBox(
              height: scheight * 0.01,
            ),
            Container(
                width: scwidth * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.deepPurple, width: 2)),
                child: Padding(
                    padding: EdgeInsets.all(scwidth * 0.02),
                    child: TextField(
                        controller: _password,
                        style: simpleTextFieldStyle(),
                        obscureText: true,
                        decoration: textfield("Password")))),
            SizedBox(
              height: scheight * 0.01,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Forget Password?",
                  style: simpleTextFieldStyle(),
                ),
              ),
            ),
            SizedBox(
              height: scheight * 0.01,
            ),
            GestureDetector(onTap: (){
              signIn();
            },
              child: Container(width: scwidth * 0.4,
                decoration: BoxDecoration(color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(22)),
                  child: Padding(
                    padding:  EdgeInsets.all(scwidth*0.02),
                    child: Center(child: Text('Login',style: TextStyle(color: Colors.white,fontSize:22 ),)),
                  ),
                ),
            ),
            SizedBox(height: scheight*0.01,),
            GestureDetector(onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Signup()));
            },
              child: Container(width: scwidth * 0.6,
                decoration: BoxDecoration(color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding:  EdgeInsets.all(scwidth*0.02),
                  child: Center(child: Text('Create Account',style: TextStyle(color: Colors.white,fontSize:22 ),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
