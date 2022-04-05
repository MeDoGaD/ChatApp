import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String shareprefUserLoggedKey="ISLOGGEDIN";
  static String shareprefUsernameKey="USERNAMEKEY";
  static String shareprefUseremailKey="USEREMAILKEY";

  static Future<bool>saveUserLoggedIN(bool isUserLoggedIn)async
  {
   SharedPreferences prefs=await SharedPreferences.getInstance();
   return await prefs.setBool(shareprefUserLoggedKey, isUserLoggedIn);
  }

  static Future<bool>saveUsername(String Username)async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(shareprefUsernameKey, Username);
  }

  static Future<bool>saveUserEmail(String Useremail)async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(shareprefUseremailKey, Useremail);
  }

  static Future<bool?>getUserLoggedIN()async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getBool(shareprefUserLoggedKey);
  }

  static Future<Object?>getUsername()async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.get(shareprefUsernameKey);
  }

  static Future<Object?>getUserEmail()async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.get(shareprefUseremailKey);
  }
}