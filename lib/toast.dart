import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ShowToast{
  String message;

  ShowToast(this.message){
    Fluttertoast.cancel();
    this.message = message;
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
  
}