import 'package:mychat/helper/constants.dart';
import 'package:mychat/helper/helperfunctions.dart';
import 'package:mychat/pages/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychat/services/database.dart';
import 'package:mychat/Widgets/widget.dart';

import 'chat_room.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

String _myName="";

class _SearchState extends State<Search> {
  TextEditingController _searchResult = new TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  QuerySnapshot? searchsnapshot;

  initialSearch() {
    dataBaseMethods.getUserByUsername(_searchResult.text).then((val) {
      print(val.toString());
      setState(() {
        searchsnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({String? username}) {
    if (username != Constants.myname) {
      String ChatRoomID = getChatRoomID(username!, Constants.myname);
      List<String> users = [username, Constants.myname];
      Map<String, dynamic> chatRoomMap = {
        "Users": users,
        "ChatRoomID": ChatRoomID
      };
      DataBaseMethods().createChatRoom(ChatRoomID, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Conversation_Screen(ChatRoomID,username)));
    }
  }

  Widget searchList() {
    return searchsnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchsnapshot!.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                username: searchsnapshot!.docs[index].get("name"),
                useremail: searchsnapshot!.docs[index].get("email"),
              );
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget searchTile({String? username,  String? useremail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username!,
                style: mediumTextStyle(),
              ),
              Text(
                useremail!,
                style: mediumTextStyle(),
              ),
            ],
          ),
          Spacer(),
         username!=Constants.myname?GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(username: username);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: mediumTextStyle(),
              ),
            ),
          ):SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54ffffff),
              height: MediaQuery.of(context).size.height / 9,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: TextField(
                      controller: _searchResult,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Search by username",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      initialSearch();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0x36ffffff),
                            Color(0x0fffffff),
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      padding: EdgeInsets.all(9),
                      child: Image.asset(
                        "assets/search.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

class searchTile extends StatelessWidget {
  final String? username;
  final String? useremail;
  searchTile({this.username, this.useremail});
  @override
  Widget build(BuildContext context) {
    return searchTile();
  }
}

getChatRoomID(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
    return "$b\_$a";
  else
    return "$a\_$b";
}
