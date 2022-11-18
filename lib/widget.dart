import 'package:deardiary/pages/setup/HomePage.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/services/sharedpreferencehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text('Dear Diary'),
  );
}

Widget discardStory(
  BuildContext context,
  String title,
) {
  return AppBar(
      title: Text(title),
      flexibleSpace: Container(
        decoration: darkTheme(),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            SharedPreferenceHelper().discardStory(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.close),
          ),
        )
      ]);
}

Widget loadingScreen() {
  return Container(
    decoration: backgroundDecorationV2(),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(top: 10)),
          Text('Loading please be patient',
              style: TextStyle(
                  fontFamily: 'Lato', fontSize: 20, color: Colors.black))
        ],
      ),
    ),
  );
}

Widget loadingScreenForFinish() {
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(decoration: darkTheme()),
    ),
    body: Container(
      decoration: backgroundDecorationV2(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text('Loading please be patient',
                style: TextStyle(
                    fontFamily: 'Lato', fontSize: 20, color: Colors.black))
          ],
        ),
      ),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText, Icon icon) {
  return InputDecoration(
    hintText: "$hintText",
    hintStyle: TextStyle(color: Colors.grey[500]),
    prefixIcon: icon,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  );
}

InputDecoration textFieldInputDecorationV2(
    String hintText, Icon icon, bool isError) {
  return InputDecoration(
    hintText: "$hintText",
    errorText: isError ? null : 'Please check your current password',
    hintStyle: TextStyle(color: Colors.grey[500]),
    prefixIcon: icon,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  );
}

InputDecoration textFieldInputDecoration2(String hintText) {
  return InputDecoration(
      hintText: "$hintText",
      hintStyle: TextStyle(color: Colors.black),
      border: OutlineInputBorder());
}

BoxDecoration backgroundDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        // Colors.black38,
        // Colors.black12,
        // Colors.black26
        Colors.white30,
        Colors.white30
      ],
    ),
  );
}

BoxDecoration backgroundDecorationV2() {
  return BoxDecoration(
      color: Colors.white);
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}

TextStyle simpleTextStyleV2() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}

TextStyle simpleStoriesTextStyle() {
  return TextStyle(
    fontSize: 22,
    color: Colors.black54,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.8,
  );
}

TextStyle signInTextStyle() {
  return TextStyle(
      fontSize: 20,
      color: Colors.black54,
      letterSpacing: -0.8,
      fontFamily: 'Quelity');
}

TextStyle carouselTextStyle() {
  return TextStyle(
      inherit: true,
      fontSize: 22.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'Quelity',
      shadows: [
        Shadow(
            // bottomLeft
            offset: Offset(-1.5, -1.5),
            color: Colors.black),
        Shadow(
            // bottomRight
            offset: Offset(1.5, -1.5),
            color: Colors.black),
        Shadow(
            // topRight
            offset: Offset(1.5, 1.5),
            color: Colors.black),
        Shadow(
            // topLeft
            offset: Offset(-1.5, 1.5),
            color: Colors.black),
      ]);
}

showLoadingScreenV2(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: Center(
                child: CircularProgressIndicator(),
              )),
        ),
      );
    },
  );
}

showImagePopUp(dynamic story, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(story['imageUrl'],
                        width: MediaQuery.of(context).size.width,
                        height: 320,
                        fit: BoxFit.fill),
                  ),
                  SizedBox(height: 10),
                  Text(
                    story['title'],
                    style: simpleStoriesTextStyle(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

BoxDecoration mainGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white30,
        Colors.white30,
      ],
    ),
  );
}

BoxDecoration darkTheme() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white30,
        Colors.white30,
      ],
    ),
  );
}

Future<bool> onBackPressed(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit Dear Diary?', style: TextStyle(color: Colors.red)),
          content: Text('Are you sure you want this exit?'),
          actions: [
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  SystemNavigator.pop();
                }),
          ],
        );
      });
}

Future<bool> onBackPressedOnCreatingStory(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Discard', style: TextStyle(color: Colors.red)),
          content: Text('Are you sure you want to discard story?'),
          actions: [
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pop(context, true);
                  SharedPreferenceHelper().discardStory(context);
                }),
          ],
        );
      });
}

// Widget cancelButton(BuildContext context, String cancelText) {
//   return FlatButton(
//     child: Text("$cancelText"),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );
// }

Widget continueButton(BuildContext context, String continueText) {
  return FlatButton(
      child: Text("$continueText"),
      onPressed: () {
        Navigator.of(context).pop();
      });
}

Future<void> showDialogMain(BuildContext context, String continueText,
    String dialogTitle, String contentText) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$dialogTitle', style: TextStyle(color: Colors.red)),
          content: Text('$contentText'),
          actions: [continueButton(context, continueText)],
        );
      });
}
