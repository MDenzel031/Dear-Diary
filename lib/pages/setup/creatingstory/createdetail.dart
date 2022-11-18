import 'dart:io';

import 'package:deardiary/pages/setup/HomePage.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/creatingstory/insertimage.dart';
import 'package:deardiary/pages/setup/publicstorieshomepage.dart';
import 'package:deardiary/services/cloudstorage.dart';
import 'package:deardiary/services/sharedpreferencehelper.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateDetail extends StatefulWidget {
  String getTitle;

  CreateDetail(this.getTitle);
  @override
  _CreateDetailState createState() => _CreateDetailState();
}

class _CreateDetailState extends State<CreateDetail> {
  final formkey = GlobalKey<FormState>();
  TextEditingController detailController = TextEditingController();
  String detail;
  bool isLoading = false;
  bool isPublic = true;
  String viewed = 'Public';

  saveDetailAndFinish() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String uid = pref.getString('userIDReference');
    SharedPreferenceHelper sharedPreferenceHelper =
        SharedPreferenceHelper(uid: uid);

    if (formkey.currentState.validate()) {
      detail = detailController.text;
      pref.setString('detail', detail);
      // ShowToast('Sucessfully Saved');

      String date = pref.getString('date');
      String title = pref.getString('title');

      File fileImage = File(pref.getString('imageUrl'));
      String theImageUrl =
          await CloudStorageService().saveImageToCloud(fileImage);

      String getdetail = pref.getString('detail');

      sharedPreferenceHelper.saveInFirebase(
          title, theImageUrl, getdetail, date, isPublic);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainHomePage()));

      ShowToast('Sucessfully Saved');
    } else {
      ShowToast('Something went wrong');
    }

    setState(() {
      isLoading = false;
    });
  }

  _navigatePrevious() async {
    if (detailController.text != null) {
      await SharedPreferenceHelper().saveDetail(detailController.text);
    }
    String title = await SharedPreferenceHelper().getTitle();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => InsertImage(title)));
  }

  _checkDetail() async {
    String detail = await SharedPreferenceHelper().getDetail();
    if (detail != null) {
      setState(() {
        detailController.text = detail;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkDetail();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? loadingScreenForFinish()
        : Scaffold(
            appBar: discardStory(
              context,
              'Create Detail',
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: darkTheme(),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'What happend in your story: ${widget.getTitle}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white54,
                            fontFamily: 'Quelity'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: formkey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          maxLines: 18,
                          controller: detailController,
                          style: simpleTextStyle(),
                          validator: (val) {
                            return val.isEmpty
                                ? 'Must Provide some detail'
                                : null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: SwitchListTile(
                        onChanged: (value) {
                          setState(() {
                            isPublic = value;
                            isPublic == true
                                ? viewed = 'Public'
                                : viewed = 'Private';
                          });
                          print(isPublic);
                        },
                        subtitle: Text('How will it be viewed?'),
                        value: isPublic,
                        title: Text('$viewed'),
                        secondary: isPublic == true
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: saveDetailAndFinish,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width - 250,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    const Color(0xff007EF4),
                                    const Color(0xff2A75BC),
                                  ]),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Finish",
                                style: simpleTextStyle(),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                        Expanded(
                          child: GestureDetector(
                            onTap: _navigatePrevious,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width - 250,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    const Color(0xff007EF4),
                                    const Color(0xff2A75BC),
                                  ]),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Previous",
                                style: simpleTextStyle(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
