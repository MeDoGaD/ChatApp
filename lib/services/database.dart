

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mychat/helper/constants.dart';

class DataBaseMethods {

 Future CheckUsername(String username)async{
    bool valid=true;
    await FirebaseFirestore.instance.collection("Users").get().then((value){
      value.docs.forEach((element) {
        if(element.id==username)
          {
            valid=false;
          }
      });
    });
    return valid;
  }
   UsernameFound(String username)async{
     return await FirebaseFirestore.instance.collection("Users").where("name",isEqualTo:username).get();
  }
  UseremailFound(String useremail)async{
    return await FirebaseFirestore.instance.collection("Users").where("email",isEqualTo:useremail).snapshots();
  }

  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUseremail(String useremail) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: useremail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("Users").doc(userMap["name"]).set(userMap);
  }
   uploadUserData(String id,String email,token) {
     FirebaseFirestore.instance.collection("Users").doc(id).set({
       "email":email,
       "fcmToken":token
     });
   }

  createChatRoom(String ChatRoomId, ChatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(ChatRoomId)
        .set(ChatRoomMap);
  }
  
  createIsTypingState(String ChatRoomId, state){
    FirebaseFirestore.instance.collection("ChatRoom").doc(ChatRoomId).collection("istyping").add(state);
  }

  addConversationMsgs(String ChatRoomId, messgaeMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(ChatRoomId)
        .collection("chats")
        .add(messgaeMap);
  }

  returnIsTypingState(String ChatRoomId,String myname)async{
    bool istyping=false;
     await FirebaseFirestore.instance.collection("ChatRoom").doc(ChatRoomId).collection("istyping").orderBy("time",descending: false).get()
        .then((QuerySnapshot snapshot) {
        for(int i=0;i<snapshot.docs.length;i++){
           if(myname==snapshot.docs[i].get("sendby")&&snapshot.docs[i].get("istyping")==1)
             {
               print("yup");
               return true;
             }
        }
    });
  }

  getConversationMsgs(String ChatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(ChatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("Users", arrayContains: username)
        .snapshots();
  }
   updateUserToken(String token, String username) async {
      await FirebaseFirestore.instance
         .collection("Users").doc(username).update({"fcmToken": token});
   }

}
