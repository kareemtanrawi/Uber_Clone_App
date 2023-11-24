import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonMethods{
  static displaySnackBar(String messageText , BuildContext context){
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}