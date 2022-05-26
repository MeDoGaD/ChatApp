import 'package:flutter/material.dart';

InputDecoration textfield(String hint)
{
  return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white60),border: InputBorder.none
      );

}

TextStyle simpleTextFieldStyle(){
  return TextStyle(color: Colors.white,fontSize:16,decoration: TextDecoration.underline );
}

TextStyle mediumTextStyle(){
  return TextStyle(color: Colors.white,fontSize:16);
}