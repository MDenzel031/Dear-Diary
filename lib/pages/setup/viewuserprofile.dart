import 'package:deardiary/authenticate.dart';
import 'package:deardiary/pages/setup/editUser.dart';
import 'package:deardiary/pages/setup/editaccount.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';

class ViewUserProfile extends StatefulWidget {
  dynamic ref;
  ViewUserProfile(this.ref);

  @override
  _ViewUserProfileState createState() => _ViewUserProfileState();
}

class _ViewUserProfileState extends State<ViewUserProfile> {
  var userDetails;
  bool isLoading = false;
  String userDescription;
  String valueChoose;
  List settingsItem = ['Profile Edit', 'Account Edit'];

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
          leading: Container(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userDetails['userImage']),
            ),
          ),
          leadingWidth: 60,
          title: Text(userDetails['userName']),
          flexibleSpace: Container(
            decoration: darkTheme(),
          ),
          actions: [
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => EditUser(userDetails)));
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(15),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [Icon(Icons.edit), Text('Edit')],
            //     ),
            //   ),
            // ),
            GestureDetector(
              child: Container(
                child: PopupMenuButton(
                  icon: Icon(Icons.settings),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditUser(userDetails)));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.black),
                            Text(
                              'Edit Profile',
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccount(userDetails)));
                        },
                                              child: Row(
                          children: [
                            Icon(Icons.account_balance, color: Colors.black),
                            Text(
                              'Edit Account',
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: isLoading == true
            ? loadingScreen()
            : WillPopScope(
                onWillPop: () {
                  onBackPressed(context);
                },
                child: Container(
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
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    'My Profile',
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
                                    height: 400,
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
                                  alignment: Alignment.center,
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
                                                fontFamily: 'Lato',
                                                fontSize: 16,
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
                                GestureDetector(
                                  onTap: () {
                                    showChoiceDialog(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width -
                                          250,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      decoration: darkTheme(),
                                      child: Text(
                                        "Sign Out",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
