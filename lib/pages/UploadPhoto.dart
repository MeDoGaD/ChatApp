import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychat/Modal/ImageItem.dart';
import 'package:mychat/helper/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadPhoto extends StatefulWidget {
  bool isShowing;
  String Username;
  UploadPhoto({this.isShowing = false, this.Username = ""});
  @override
  _UploadPhotoState createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  final _picker = ImagePicker();
  PickedFile? image;
  var file;
  GetImage() async {
    await Permission.photos.request();
    var status = await Permission.photos.status;
    if (status.isGranted) {
      image = await _picker.getImage(source: ImageSource.gallery);
      file = File(image!.path);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Need a permission")));
    }
  }

  UploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    if (image != null) {
      await _firebaseStorage
          .ref("images/${Constants.myname}")
          .putFile(file)
          .whenComplete(() {
        Constants.downloadedImages.remove(Constants.myname);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Uploaded successfully :)")));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.black87, Colors.deepPurple],begin:Alignment.topLeft,end: Alignment.bottomRight )),
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.isShowing == false
                  ? "Upload Profile Photo"
                  : widget.Username,
              style: widget.isShowing == false
                  ? TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.bold)
                  : TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
            ),
            Container(
              width: width * 0.7,
              height: heigth * 0.4,
              child: file != null && widget.isShowing == false
                  ? Image.file(
                      file,
                      fit: BoxFit.fill,
                    )
                  : widget.isShowing == false
                      ? ImageItem(Constants.myname, 400)
                      : ImageItem(widget.Username, 400),
            ),
            widget.isShowing == false
                ? GestureDetector(onTap: ()async{
    if (file == null)
    await GetImage();
    else {
    await UploadImage();
            }}
    ,
              child: Container(width: width * 0.5,
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding:  EdgeInsets.all(width*0.02),
                  child: Center(child: Text(file == null ? "Select Image" : "Upload Image",style: TextStyle(color: Colors.deepPurple,fontSize:22 ),)),
                ),
              ),
            ):SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
