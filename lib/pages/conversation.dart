import 'package:mychat/Modal/ImageItem.dart';
import 'package:mychat/helper/constants.dart';
import 'package:mychat/pages/UploadPhoto.dart';
import 'package:mychat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Conversation_Screen extends StatefulWidget {
  final String ChatRoomID;
  final String username;
  Conversation_Screen(this.ChatRoomID, this.username);
  @override
  _Conversation_ScreenState createState() => _Conversation_ScreenState();
}

class _Conversation_ScreenState extends State<Conversation_Screen> {
  TextEditingController _MsgResult = new TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Stream? chatMessageStream;
  ScrollController _scrollController = ScrollController();
settyping(){
  if(dataBaseMethods.returnIsTypingState(widget.ChatRoomID,widget.username)==true) {
    setState(() {
      print("typing...");
      _MsgResult.text = widget.username + " is typing";
    });
  }
}


  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        settyping();
        return snapshot.hasData
            ? ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                reverse: true,
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                itemBuilder: (context, index) {
                  int len = (snapshot.data! as QuerySnapshot).docs.length;
                  return MessageTile(
                      (snapshot.data! as QuerySnapshot).docs[index]["message"],
                      (snapshot.data! as QuerySnapshot).docs[index]["date"],
                      (snapshot.data! as QuerySnapshot).docs[index]["sendby"] ==
                          Constants.myname);
                })
            : Container(
                child: Center(
                  child: Text(
                    "Type you first message here :)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
      },
    );
  }

  sendMsg(String msg) {
    if (msg.isNotEmpty) {
      Map<String, dynamic> msgMap = {
        "message": msg,
        "sendby": Constants.myname,
        "sendto":widget.username,
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
        "date": DateTime.now().hour.toString() +":"+ DateTime.now().minute.toString()
      };
      dataBaseMethods.addConversationMsgs(widget.ChatRoomID, msgMap);
      if(msg!="❤❤❤❤❤❤❤"&&msg!="❤")
           _MsgResult.text = "";
    }
  }



  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    dataBaseMethods.getConversationMsgs(widget.ChatRoomID).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showMessage("Notification", "$message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     showMessage("Notification", "$message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     showMessage("Notification", "$message");
    //   },
    // );
    super.initState();
  }
  showMessage(title, description) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Dismiss"),
              )
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(leading: GestureDetector(onTap:(){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UploadPhoto(isShowing: true,Username: widget.username,)));

      } ,child: Padding(padding: EdgeInsets.only(left:20 ),child:ImageItem(widget.username,20) ,)),
        title: Text(widget.username),
        backgroundColor: Color(0x54ffffff),
        actions: [
          Icon(
            Icons.call,
            color: Colors.blue,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 18,
          ),
          Icon(Icons.videocam, color: Colors.blue),
          SizedBox(
            width: MediaQuery.of(context).size.width / 18,
          ),
          Icon(Icons.info, color: Colors.blue),
          SizedBox(
            width: MediaQuery.of(context).size.width / 18,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ChatMessageList(),
            ),
            Container(
              //alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54ffffff),
                height: MediaQuery.of(context).size.height / 12,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                    GestureDetector(onLongPress: (){
                      sendMsg("❤❤❤❤❤❤❤");
                    },
                        onTap: () {
                          sendMsg("❤");
                        },
                        child: Icon(
                          Icons.favorite,
                          color: Colors.blue,size: 30,
                        )),
                       Container(
                          constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width *0.74,
                       maxHeight: MediaQuery.of(context).size.height*0.2),
                          padding: EdgeInsets.all(9),
                          child: Padding(
                            padding:  EdgeInsets.only(left: 4),
                            child: TextField(maxLines: 4,keyboardType: TextInputType.multiline,
                                onTap: (){
                              Map<String, dynamic> isTypingMap = {
                                "istyping": 1,
                                "sendby": Constants.myname,
                                "time":
                                DateTime.now().millisecondsSinceEpoch.toString()
                              };
                              // dataBaseMethods.createIsTypingState(
                              //     widget.ChatRoomID, isTypingMap);
                            },
                              controller: _MsgResult,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: "Message",
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none),
                            ),
                          )),

                    GestureDetector(
                      onTap: () {
                        HapticFeedback.vibrate();
                        sendMsg(_MsgResult.text);
                        Map<String, dynamic> isTypingMap = {
                          "istyping": 0,
                          "sendby": Constants.myname,
                          "time":
                          DateTime.now().millisecondsSinceEpoch.toString()
                        };
                       // dataBaseMethods.createIsTypingState(
                            //widget.ChatRoomID, isTypingMap);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        height: MediaQuery.of(context).size.height / 12,
                        width: MediaQuery.of(context).size.width / 9,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0x36ffffff),
                              Color(0x0fffffff),
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.only(
                            top: 9, bottom: 9, left: 4, right: 9),
                        child: Image.asset(
                          "assets/send.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String msg;
  final bool isSendByMe;
  final String date;
  MessageTile(this.msg, this.date, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.only(
            left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,

        alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: msg != "❤"
            ? Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isSendByMe
                      ? [
                    const Color(0xff007EF4),
                    const Color(0xff2A75BC),
                  ]
                      : [
                    const Color(0x1AFFFFFF),
                    const Color(0x1AFFFFFF),
                  ]),
              borderRadius: isSendByMe
                  ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                  topRight: Radius.circular(23))
                  : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                  topRight: Radius.circular(23))),

          child:
          Column(
            children: [
              Text(msg, style: TextStyle(color: Colors.white, fontSize: 17),),
            ],

          ),
        )
            : Text(msg, style: TextStyle(color: Colors.white, fontSize: 37),),
      ),
      msg != "❤"? Row(mainAxisAlignment:isSendByMe ? MainAxisAlignment.end:MainAxisAlignment.start,
        children: [
          Padding(
            padding:isSendByMe ? const EdgeInsets.only(right: 24):const EdgeInsets.only(left: 24),
            child: Text(date, style: TextStyle(color: Colors.white38, fontSize: 13),),
          ),
        ],
      ):Container(),
    ],);

  }
}
