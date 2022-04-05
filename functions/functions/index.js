const functions = require('firebase-functions');
const admin=require('firebase-admin')
admin.initializeApp(functions.config().functions);

exports.SendMsg=functions.firestore
.document("ChatRoom/{chatroom}/chats/{msg}")
.onCreate(async(snapshot,context)=>{
var tokens=[];
const sentToID=snapshot.data().sendto;
const sentbyID=snapshot.data().sendby;

const msg=snapshot.data().message;
const UserDoc=await admin.firestore().collection("Users").doc(sentToID).get();
const fcmToken=UserDoc.data().fcmToken;
tokens.push(fcmToken);
var payload={notification: {title:sentbyID, body: msg}
, data: {click_action:'FLUTTER_NOTIFICATION-CLICK'}}
const response = await admin.messaging().sendToDevice(tokens,payload);

});
