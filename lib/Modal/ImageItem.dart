import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mychat/helper/constants.dart';

class ImageItem extends StatefulWidget{
  String imageName;
  double size;
  ImageItem(this.imageName,this.size);
  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  var PhotosRef=FirebaseStorage.instance.ref("images");
  Uint8List? ImageBytes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFromStorage();
  }

  getImageFromStorage()async{
    if(Constants.downloadedImages.containsKey(widget.imageName)==false) {
      PhotosRef.child(widget.imageName as String)
          .getData(7 * 1024 * 1024)
          .then((value) {
        {
          Constants.downloadedImages.putIfAbsent(widget.imageName, () {
            return value as Uint8List;
          });
          setState(() {
            ImageBytes = value;
          });
        }
      });
    }
    else
      ImageBytes=Constants.downloadedImages[widget.imageName];
  }
  @override
  Widget build(BuildContext context) {
    return ImageBytes!=null?Container(width:widget.size,height: widget.size ,decoration: BoxDecoration(shape:BoxShape.circle,image: DecorationImage(fit:BoxFit.fill,image:widget.size<100?MemoryImage(ImageBytes as Uint8List):MemoryImage(ImageBytes as Uint8List)))):
    Container(
      height: widget.size,
      width: widget.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.deepPurple, shape:BoxShape.circle),
      child: Text(
        widget.imageName.substring(0, 1).toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize:widget.size>100?33:16),
      ),
    );

  }
}