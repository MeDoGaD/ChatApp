import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
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
}
