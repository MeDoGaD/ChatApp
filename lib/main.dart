import 'package:firebase_core/firebase_core.dart';
import 'package:mychat/pages/chat_room.dart';
import 'package:mychat/pages/conversation.dart';
import 'package:mychat/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:mychat/pages/login.dart';
import 'package:mychat/helper/helperfunctions.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn=false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
  getLoggedInState()async{
    await HelperFunctions.getUserLoggedIN().then((value) {
      setState(() {
        isLoggedIn=value!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
  if(isLoggedIn==null)
    {
      return MaterialApp(
        home: Login(),
      );
    }
  else {
    return MaterialApp(
      home: isLoggedIn ? ChatRoomsScreen() : Login(),
    );
  }

  }
}

