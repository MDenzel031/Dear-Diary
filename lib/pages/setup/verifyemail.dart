import 'dart:async';

import 'package:deardiary/authenticate.dart';
import 'package:deardiary/pages/setup/HomePage.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/publicstorieshomepage.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/services/database.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmail extends StatefulWidget {
  // String email,userName,uid;

  // VerifyEmail(this.userName,this.email,this.uid);
  //
  String email;

  VerifyEmail(this.email);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifying'),
        flexibleSpace: Container(
          decoration: darkTheme(),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              showChoiceDialog(context);
            },
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.cancel_presentation_rounded),
            ),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        height: double.infinity,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  'Email has been sent to ${widget.email} please verify',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();

    if (user.emailVerified) {
      timer.cancel();
      final pref = await SharedPreferences.getInstance();
      ShowToast('Sucessfully Added');
      pref.setString('userIDReference', user.uid);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MainHomePage()));
    }
  }


   Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(this.context).pop();
      },
    );
  }

  Widget continueButton(BuildContext context) {
    return FlatButton(
      child: Text("Abort"),
      onPressed: () {
        Navigator.of(this.context).pop();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
      },
    );
  }

  Future<void> showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Abort', style: TextStyle(color: Colors.red)),
            content: Text('Cancel the verification?'),
            actions: [cancelButton(context), continueButton(this.context)],
          );
        });
  }
}
