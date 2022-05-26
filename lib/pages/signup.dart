import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/Draw/drawer.dart';
import 'package:mychat/Widgets/widget.dart';
import 'package:mychat/services/auth.dart';
import 'package:mychat/services/database.dart';
import 'chat_room.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'package:mychat/helper/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Signup extends StatefulWidget {

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  AuthMethods authMethods=new AuthMethods();
  DataBaseMethods dataBaseMethods=new DataBaseMethods();
  bool isloading=false;
  final formkey=GlobalKey<FormState>();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _email = new TextEditingController();
FirebaseMessaging firebaseMessaging= FirebaseMessaging.instance;
  signMeUp() async {
    if(formkey.currentState!.validate()) {

          setState(() {isloading=true;});
          await dataBaseMethods.CheckUsername(_username.text).then((value) =>{
            if(value==true)
              {
              authMethods.signUpwithEmailAndPassword(_email.text, _password.text).then((value)async {
            String? fcmtoken =await firebaseMessaging.getToken();
            if(AuthMethods.found==true) {
              Map<String, dynamic>usermap = {
                "email": _email.text,
                "name": _username.text,
                "fcmToken":fcmtoken
              };
              HelperFunctions.saveUserLoggedIN(true);
              HelperFunctions.saveUsername(_username.text);
              HelperFunctions.saveUserEmail(_email.text);
              dataBaseMethods.uploadUserInfo(usermap);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoomsScreen()));
            }
            else
            {
              showDialog(context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(title: Text('Registered failed :( ',
                      style: TextStyle(color: Colors.deepPurple),),
                      content: Text('The username or email isn'+"'"+'t available'),
                      actions: <Widget>[
                        FlatButton(child: Text('Ok',
                          style: TextStyle(
                              color: Colors.deepPurple),),
                            onPressed: () {
                              HapticFeedback.vibrate();
                              Navigator.of(context).pop();
                            }),
                      ],);
                  });
              setState(() {isloading=false;});
            }}),
              }
            else
              {
              showDialog(context: context,
              builder: (BuildContext context) {
                return AlertDialog(title: Text('Registered failed :( ',
                  style: TextStyle(color: Colors.deepPurple),),
                  content: Text('The username isn'+"'"+'t available'),
                  actions: <Widget>[
                    FlatButton(child: Text('Ok',
                      style: TextStyle(
                          color: Colors.deepPurple),),
                        onPressed: () {
                          HapticFeedback.vibrate();
                          Navigator.of(context).pop();
                        }),
                  ],);
              }),
          setState(() {isloading=false;})
    }
          });

      }
  }
  @override
  Widget build(BuildContext context) {
    double scheight = MediaQuery.of(context).size.height;
    double scwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black87,
      body:isloading?Container(child:Center(child: CircularProgressIndicator()) ,): Center(
        child:   Column(children: [
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
                              top: scheight * 0.14, left: scwidth * 0.2),
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.white,
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
            Form(key: formkey,child: Column(
              children: [
                Container(
                    width: scwidth * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.deepPurple, width: 2)),
                    child: Padding(
                        padding: EdgeInsets.all(scwidth * 0.02),
                        child: TextFormField(validator: (val){
                  return val!.isEmpty||val.length<2 || val.contains(' ') ? 'Please provide a valid Username':null;
                },controller: _username,style: simpleTextFieldStyle(),
                  decoration:textfield("Username"),))),
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
                        child: TextFormField(validator: (val){
                  return RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})").hasMatch(val!)?null:'Please provide a valid the email';
                },controller: _email,style: simpleTextFieldStyle(),
                    decoration:textfield("Email")))),
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
                        child: TextFormField(obscureText: true,validator: (val){
                  return val!.length<6 ? 'The password must be larger than 6 characters':null;
                },controller: _password,style: simpleTextFieldStyle(),
                    decoration:textfield("Password")))),
              ],
            ),),
            SizedBox(height: scheight*0.05,),
              GestureDetector(onTap: (){
                signMeUp();
              },
                child: Container(width: scwidth * 0.4,
                  decoration: BoxDecoration(color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding:  EdgeInsets.all(scwidth*0.02),
                    child: Center(child: Text('SignUp',style: TextStyle(color: Colors.white,fontSize:22 ),)),
                  ),
                ),
              ),
            SizedBox(height:scheight*0.015,),
            GestureDetector(onTap: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
            },
              child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text("Already have account? ",style: mediumTextStyle(),),
                Text("SignIn Now",style: TextStyle(color: Colors.white60,fontSize:16,decoration:TextDecoration.underline ),),
              ],),
            )
          ],),),


    );
  }
}
