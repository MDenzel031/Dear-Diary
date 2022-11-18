import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/pages/setup/HomePage.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/publicstorieshomepage.dart';
import 'package:deardiary/services/cloudstorage.dart';
import 'package:deardiary/services/database.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditStory extends StatefulWidget {
  dynamic story;
  bool isPublic;
  String viewed;
  bool defaultViewed;
  EditStory(dynamic story, bool isPublic) {
    this.story = story;
    this.isPublic = isPublic;
    viewed = this.isPublic == true ? 'Public' : 'Private';
    defaultViewed = isPublic;
  }

  @override
  _EditStoryState createState() => _EditStoryState();
}

class _EditStoryState extends State<EditStory> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  File imageFile;
  String imageUrl;
  ImagePicker picker = ImagePicker();
  final formkey = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();

  _displayStoryDetails() async {
    imageUrl = widget.story['imageUrl'];
    setState(() {
      titleController.text = widget.story['title'];
      detailController.text = widget.story['detail'];
    });
  }

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
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image:
              DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover),
        ),
      );
    } else {
      return Container(
        height: 350,
        child: Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: NetworkImage(widget.story['imageUrl']),
                fit: BoxFit.cover),
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
  updateUserDetails(BuildContext context) async {
    if (imageFile != null || imageUrl != null) {
      showLoadingScreenV2(context);
      //FOR STORING THE IMAGE IN CLOUD STORAGE
      if (imageFile != null) {
        imageUrl = await cloudStorage.saveImageToCloud(imageFile);
      }

      //GETTING THE COLLECTION FROM 'story' IN FIREBASE
      String docUid = widget.story['id'];
      print('The Story ID: $docUid');
      DocumentReference userReferences =
          await dataMethods.getUserDocFromStory(docUid, widget.defaultViewed);

      print('VIEWED VALUE IS: ${widget.defaultViewed == widget.isPublic}');
      if (widget.defaultViewed == widget.isPublic) {
        ShowToast('IT REACH THE SAME DEFAULT VIEWED VALUE');
        if (formkey.currentState.validate() &&
            formkey2.currentState.validate()) {
          Map<String, dynamic> updateData = {
            'viewed': widget.isPublic,
            'date': widget.story['date'],
            'title': titleController.text,
            'imageUrl': imageUrl,
            'detail': detailController.text,
          };

          await userReferences.update(updateData);
        }
      } else {
        await userReferences.delete();
        final pref = await SharedPreferences.getInstance();
        String uid = await pref.getString('userIDReference');
        String newViewed = !widget.defaultViewed == true ? 'Public' : 'Private';
        CollectionReference newReference = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('story')
            .doc(uid)
            .collection(newViewed);
        Map<String, dynamic> newData = {
          'viewed': widget.isPublic,
          'date': widget.story['date'],
          'title': titleController.text,
          'imageUrl': imageUrl,
          'detail': detailController.text,
        };
        newReference.add(newData);
      }

      ShowToast('Sucessfully Updated Story');
      Navigator.pop(context, true);
      Navigator.pop(context, true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainHomePage()));

      //MAP FOR UPDATING THE USERS FROM THE FIREBASE

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _displayStoryDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            title: Text(widget.story['title']),
            actions: [
              GestureDetector(
                  onTap: () {
                    updateUserDetails(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Icon(Icons.update_rounded),
                        Text('Update Story'),
                      ],
                    ),
                  ))
            ],
            pinned: true,
            expandedHeight: 500.0,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  showImagePopUp(widget.story, context);
                },
                child: imageFile != null
                    ? Image.file(imageFile, fit: BoxFit.cover)
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 80,
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white10,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: GestureDetector(
                    onTap: () {
                      showChoiceDialog(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 200,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 10),
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
                ),
              )
            ]),
          ),
          SliverFixedExtentList(
            itemExtent: 100,
            delegate: SliverChildListDelegate([
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width - 200,
                padding: EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SwitchListTile(
                  onChanged: (value) {
                    setState(() {
                      widget.isPublic = value;
                      widget == true
                          ? widget.viewed = 'Public'
                          : widget.viewed = 'Private';
                    });
                  },
                  subtitle: Text('How will it be viewed?'),
                  value: widget.isPublic,
                  title: Text('${widget.viewed}'),
                  secondary: widget.isPublic == true
                      ? Icon(
                          Icons.public_rounded,
                          size: 50,
                          color: Colors.blueAccent,
                        )
                      : Icon(
                          Icons.lock,
                          size: 50,
                          color: Colors.redAccent,
                        ),
                ),
              ),
            ]),
          ),
          SliverFixedExtentList(
            itemExtent: 200.0,
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white30,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Story Title:',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Lato',
                        ),
                      ),
                      Text(
                        widget.story['title'],
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Lato',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Form(
                          key: formkey,
                          child: TextFormField(
                            maxLength: 25,
                            textAlign: TextAlign.center,
                            controller: titleController,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            validator: (val) {
                              return val.isEmpty
                                  ? 'Must Provide some detail'
                                  : null;
                            },
                            decoration: textFieldInputDecoration2(
                                'Explain what happen..'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          SliverFixedExtentList(
            itemExtent: 500.0,
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white30,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Lato',
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Form(
                              key: formkey2,
                              child: TextFormField(
                                maxLines: 20,
                                controller: detailController,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                                validator: (val) {
                                  return val.isEmpty
                                      ? 'Must Provide some detail'
                                      : null;
                                },
                                decoration: textFieldInputDecoration2(
                                    'Explain what happen..'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
