import 'package:deardiary/pages/setup/creatingstory/insertimage.dart';
import 'package:deardiary/services/sharedpreferencehelper.dart';
import 'package:deardiary/showdate.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTitle extends StatefulWidget {
  @override
  _CreateTitleState createState() => _CreateTitleState();
}

class _CreateTitleState extends State<CreateTitle> {
  final formkey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();

  saveTitleAndNavigate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String uid = pref.getString('userIDReference');
    SharedPreferenceHelper sharedPreferenceHelper =
        SharedPreferenceHelper(uid: uid);

    if (formkey.currentState.validate()) {
      sharedPreferenceHelper.saveTitle(titleController.text);
      await sharedPreferenceHelper.saveDate(date);
      String theTitle = await sharedPreferenceHelper.getTitle();
      // ShowToast('${theTitle} ${date}');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => InsertImage(theTitle)));
    } else {
      ShowToast('Error has come up');
    }
  }

  _checkTitle() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String title = pref.getString('title');
    if (title != null) {
      setState(() {
        titleController.text = title;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkTitle();
  }

  @override
  Widget build(BuildContext context) {
    // void navigateNext() {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => InsertImage()));
    // }

    return Scaffold(
      appBar: discardStory(
        context,
        'Create Title',
      ),
      body: WillPopScope(
        onWillPop: (){
          onBackPressedOnCreatingStory(context);
        },
              child: Stack(
          children: [
            Positioned(
              top: 10,
              bottom: 10,
              child: ShowDate(),
            ),
            Container(
              decoration:darkTheme(),
              //  BoxDecoration(
              //   gradient: LinearGradient(
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //       colors: [
              //         HexColor('#0F2027'),
              //         HexColor('#203A43'),
              //         HexColor('#2C5364')
              //       ]),
              // ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Story Title:',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quelity',
                          color: Colors.white),
                    ),
                    Form(
                      key: formkey,
                      child: TextFormField(
                        controller: titleController,
                        textAlign: TextAlign.center,
                        maxLength: 35,
                        validator: (val) {
                          return val.isEmpty ? 'Please fill title' : null;
                        },
                        style: simpleTextStyle(),
                        decoration: InputDecoration(
                          hintText: "Story Title",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: saveTitleAndNavigate,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC),
                            ]),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Next",
                          style: simpleTextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
