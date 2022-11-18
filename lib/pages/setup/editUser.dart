import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/pages/setup/HomePage.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/publicstorieshomepage.dart';
import 'package:deardiary/services/cloudstorage.dart';
import 'package:deardiary/services/cloudstorageresult.dart';
import 'package:deardiary/services/database.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUser extends StatefulWidget {
  dynamic ref;
  EditUser(this.ref);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  File imageFile;
  String imageUrl, username;
  final picker = ImagePicker();
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _openGallery(BuildContext context) async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });

      Navigator.of(context).pop();
    } else {}
  }

  _openCamera(BuildContext context) async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.of(context).pop();
    } else {}
  }

  Future<void> showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Make a choice'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  //
  Widget _imageIndicator() {
    if (imageFile != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width,
        height: 400,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              )
            ],
            image: DecorationImage(
              image: FileImage(imageFile),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: imageUrl != null
              ? Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                    image: DecorationImage(
                        image: NetworkImage(imageUrl), fit: BoxFit.fill),
                  ),
                )
              : Center(
                  child: Text('No Image'),
                ),
        ),
      );
    }
  }

  //CLASSES NECESSARY FOR THIS FUNCTION BELOW
  CloudStorageService cloudStorage = CloudStorageService();
  DataMethods dataMethods = DataMethods();
  //CLASSES NECESSARY FOR THIS FUNCTION BELOW

  //UPDATES USERS COLLECTION FROM 'users' COLLECTION
  updateUserDetails() async {
    ShowToast('Processing..');
    if (imageFile != null || imageUrl != null) {
      //FOR STORING THE IMAGE IN CLOUD STORAGE
      if (imageFile != null) {
        imageUrl = await cloudStorage.saveImageToCloud(imageFile);
      }
      var userRef = await widget.ref;
      //GETTING THE COLLECTION FROM 'users' IN FIREBASE
      DocumentReference userReferences =
          await dataMethods.getUserDocFromUsers();

      //MAP FOR UPDATING THE USERS FROM THE FIREBASE
      if (formkey.currentState.validate()) {
        Map<String, dynamic> updateData = {
          'userName': userNameController.text,
          'userEmail': userRef['userEmail'],
          'userImage': imageUrl,
          'userDescription' : descriptionController.text,
        };
        setState(() {
          isLoading = true;
        });
        userReferences.update(updateData);
        ShowToast('Sucessfully Saved');
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainHomePage()));
      }
    }

    setState(() {
      isLoading = false;
    });
  }
  //UPDATES USERS COLLECTION FROM 'users' COLLECTION

  //AS THE USER OPENS UP THE EDIT DETAILS THIS WILL PROC
  _checkUserImage() async {
    try {
      setState(() {
        isLoading = true;
      });
      DocumentReference userReferences =
          await dataMethods.getUserDocFromUsers();
      dynamic user = await userReferences.get();
      setState(() {
        imageUrl = user['userImage'];
        isLoading = false;
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  _displayUserName() async {
    DocumentReference userReferences = await dataMethods.getUserDocFromUsers();
    dynamic user = await userReferences.get();
    setState(() {
      username = user['userName'];
      userNameController.text = user['userName'];

      descriptionController.text = user['userDescription'] != null ? user['userDescription'] : null;
    });
    // ShowToast('IS THIS ACESSED? ${user['userName']} ');
  }

  @override
  void initState() {
    super.initState();
    _checkUserImage();
    _displayUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: darkTheme(),
        ),
        title: Text('Edit Profile'),
        actions: [
          GestureDetector(
            onTap: () {
              updateUserDetails();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(Icons.exit_to_app),
                  Text('Save'),
                ],
              ),
            ),
          )
        ],
      ),
      body: isLoading == true
          ? loadingScreen()
          : Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Note: Do not forget to save the changes.",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 15,
                                  color: Colors.redAccent),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          _imageIndicator(),
                          GestureDetector(
                            onTap: () {
                              showChoiceDialog(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width - 200,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    const Color(0xff007EF4),
                                    const Color(0xff2A75BC),
                                  ]),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Browse Image",
                                style: simpleTextStyle(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white30,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 10, bottom: 3),
                            child: Text(
                              'Current Username: $username',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ),
                          Form(
                            key: formkey,
                            child: Column(
                              children: [
                                TextFormField(
                                  maxLength: 30,
                                  controller: userNameController,
                                  textAlign: TextAlign.center,
                                  validator: (val) {
                                    return val.isEmpty || val.length < 5
                                        ? 'InvalidUsername must be provided 5+ characters'
                                        : null;
                                  },
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Write username",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(left: 10, bottom: 3),
                                  child: Text(
                                    'Description: ',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: 'Lato'),
                                  ),
                                ),
                                TextFormField(
                                  maxLines: 10,
                                  controller: descriptionController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Write about yourself",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
