import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychat/Modal/user.dart';
class AuthMethods{
  static bool found=true;
final FirebaseAuth _auth =FirebaseAuth.instance;
  Auth_User? _userFromFirebaseUSer(UserCredential user)
{
  return user !=null?Auth_User(userId:user.user!.uid):null;
}
Future signInWithEmailAndPassword(String email,String password)async{
 try{
   UserCredential result =await _auth.signInWithEmailAndPassword(email: email, password: password);
   return _userFromFirebaseUSer(result);
 }
 catch(e){
print(e);
 }
}

Future signUpwithEmailAndPassword(String email,String password)async{
  try{
    UserCredential result =await _auth.createUserWithEmailAndPassword(email: email, password: password);
    found=true;
    return _userFromFirebaseUSer(result);
  }
  catch(e){
    found=false;
  }
}

Future resetpass(String email)async{
  try{
    return await _auth.sendPasswordResetEmail(email: email);
  }
  catch(e){
    print(e);
  }
}

Future signOut()async{
  try{
    return await _auth.signOut();
  }
  catch(e){
    print(e);
  }
}


}