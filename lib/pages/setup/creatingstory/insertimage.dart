import 'dart:io';
import 'package:deardiary/pages/setup/creatingstory/createdetail.dart';
import 'package:deardiary/pages/setup/creatingstory/creatingtitle.dart';
import 'package:deardiary/services/sharedpreferencehelper.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsertImage extends StatefulWidget {
  String title;

  InsertImage(this.title);

  @override
  _InsertImageState createState() => _InsertImageState();
}

class _InsertImageState extends State<InsertImage> {
  File imageFile;
  String imageUrl;
  bool isLoading = false;
  final picker = ImagePicker();

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

  _saveImageAndNavigate() async {
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      final SharedPreferences pref = await SharedPreferences.getInstance();

      //FOR STORING THE IMAGE IN CLOUD STORAGE
      // FirebaseStorage storage = FirebaseStorage.instance;
      // var snapshot = await storage
      //     .ref()
      //     .child('Images/${imageFile.uri}')
      //     .putFile(imageFile);
      // var donwloadUrl = await snapshot.ref.getDownloadURL();
      // imageUrl = donwloadUrl;
      // //FOR STORING THE IMAGE IN CLOUD STORAGE

      // String uid = pref.getString('userIDReference');
      // SharedPreferenceHelper sharedPreferenceHelper =
      //     SharedPreferenceHelper(uid: uid);
      await SharedPreferenceHelper().saveImageUrl(imageFile.path);
      // Future<String> imageUrlName = await sharedPreferenceHelper.saveImageUrl(imageUrl);
      // ShowToast(imageUrlName.toString());

      // ShowToast(imageFile.path);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CreateDetail(pref.getString('title'))));
    } else {
      ShowToast('Please Enter Image');
    }
  }

  _navigatePrevious() async {
    if (imageFile != null) {
      await SharedPreferenceHelper().saveImageUrl(imageFile.path);
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CreateTitle()));
  }

  _checkImageUrl() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String theImage = pref.getString('imageUrl');
    if (theImage.isNotEmpty) {
      setState(() {
        imageFile = File(theImage);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkImageUrl();
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

  Widget _imageIndicator() {
    if (imageFile != null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: Image.file(
          imageFile,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // padding: EdgeInsets.all(5),
        // child: Placeholder(
        //   color: Colors.white,
        //   fallbackHeight: 500,
        //   fallbackWidth: MediaQuery.of(context).size.width,
        // ),
        width: double.infinity,
        height: 500,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/needimagelogo.png'),
            )
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: discardStory(
        context,
        'Insert Image',
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : WillPopScope(
            onWillPop: (){
              onBackPressedOnCreatingStory(context);
            },
                      child: Container(
                decoration: darkTheme(),
                // BoxDecoration(
                //   gradient: LinearGradient(
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //       colors: [
                //         HexColor('#89216B'),
                //         HexColor('#DA4453'),
                //       ]),
                // ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _imageIndicator(),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                                                  child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showChoiceDialog(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width - 300,
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            const Color(0xff007EF4),
                                            const Color(0xff2A75BC),
                                          ]),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Text(
                                        "Browse Image",
                                        style: simpleTextStyleV2(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _saveImageAndNavigate,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width - 300,
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            const Color(0xff007EF4),
                                            const Color(0xff2A75BC),
                                          ]),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Text(
                                        "Next",
                                        style: simpleTextStyleV2(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _navigatePrevious,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width - 300,
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            const Color(0xff007EF4),
                                            const Color(0xff2A75BC),
                                          ]),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Text(
                                        "Previous",
                                        style: simpleTextStyleV2(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ),
    );
  }
}
