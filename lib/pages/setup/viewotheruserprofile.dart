import 'package:deardiary/authenticate.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/editUser.dart';
import 'package:deardiary/pages/setup/editaccount.dart';
import 'package:deardiary/pages/setup/viewfollowing.dart';
import 'package:deardiary/pages/setup/viewuser.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';

class ViewOtherUserProfile extends StatefulWidget {
  dynamic ref;
  ViewOtherUserProfile(this.ref);

  @override
  _ViewOtherUserProfile createState() => _ViewOtherUserProfile();
}

class _ViewOtherUserProfile extends State<ViewOtherUserProfile> {
  var userDetails;
  bool isLoading = false;
  String userDescription;
  String valueChoose;

  _getUserProfileDetails() async {
    setState(() {
      userDetails = widget.ref;
      isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  _checkDescription() async {
    try {
      userDescription = userDetails['userDescription'];
    } on Exception catch (e) {
      userDescription = 'no description';
    }
    print(userDetails['userDescription']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserProfileDetails();
    _checkDescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: darkTheme(),
          ),
          title: Text('Viewing ${userDetails['userName']}'),
        ),
        body: isLoading == true
            ? loadingScreen()
            : Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Container(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  Map<String, dynamic> data = {
                                    'imageUrl': userDetails['userImage'],
                                    'title': ''
                                  };
                                  print(data['imageUrl']);
                                  showImagePopUp(data, context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 350,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                userDetails['userImage']),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  userDetails['userName'],
                                  style: simpleStoriesTextStyle(),
                                ),
                                subtitle: Text(
                                  userDetails['userEmail'],
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 15,
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userDetails['userImage']),
                                ),
                              ),
                              Divider(),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Description:',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.8,
                                      ),
                                    ),
                                    userDescription != null
                                        ? Text(
                                            userDetails['userDescription'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Lato'
                                            ),
                                          )
                                        : Text(
                                            'none',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // showChoiceDialog(context);
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MainHomePage()));
                                        
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              270,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          decoration: darkTheme(),
                                          child: Text(
                                            "Go back",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10)),
                                    GestureDetector(
                                      onTap: () {
                                        // showChoiceDialog(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ViewUser(
                                                    userDetails['userId'],
                                                    userDetails['userName'])));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              270,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          decoration: darkTheme(),
                                          child: Text(
                                            "View Stories",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
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
              ));
  }
}

// set up the buttons
Widget cancelButton(BuildContext context) {
  return FlatButton(
    child: Text("I\u0027ll stay"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

Widget continueButton(BuildContext context) {
  return FlatButton(
    child: Text("Leave"),
    onPressed: () {
      AuthMethods().signOut();
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Authenticate()));
    },
  );
}

Future<void> showChoiceDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out', style: TextStyle(color: Colors.red)),
          content: Text('You might wanna stay with us a little longer?'),
          actions: [cancelButton(context), continueButton(context)],
        );
      });
}
