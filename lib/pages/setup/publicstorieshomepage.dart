import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/authenticate.dart';
import 'package:deardiary/pages/maindrawer.dart';
import 'package:deardiary/pages/setup/creatingstory/creatingtitle.dart';
import 'package:deardiary/pages/setup/editstory.dart';
import 'package:deardiary/pages/setup/viewpublicstory.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/services/database.dart';
import 'package:deardiary/services/sharedpreferencehelper.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PublicHomePage extends StatefulWidget {
  const PublicHomePage({Key key, this.user}) : super(key: key);
  final UserCredential user;
  @override
  _PublicHomePageState createState() => _PublicHomePageState();
}

class _PublicHomePageState extends State<PublicHomePage> {
  AuthMethods _authMethods = AuthMethods();
  List userPublicStories;
  var userDetails;
  List<String> userStoriesImage = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    setState(() {
      isLoading = true;
    });
    dynamic privateStories = await DataMethods().getUsersPublicStories();
    dynamic getUserDetails=  await _authMethods.getUser();

    if (privateStories == null) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        userPublicStories = privateStories;
        userDetails = getUserDetails;
        isLoading = false;
      });
    }
  }

  // set up the buttons
  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(this.context).pop();
      },
    );
  }

  Widget continueButton(BuildContext context, String id, bool viewed) {
    return FlatButton(
      child: Text("Delete"),
      onPressed: () {
        deleteStory(id, viewed);
        Navigator.of(this.context).pop();
      },
    );
  }

  Future<void> showChoiceDialog(BuildContext context, String id, bool viewed) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete', style: TextStyle(color: Colors.red)),
            content: Text('Are you sure you want this permanently?'),
            actions: [
              cancelButton(context),
              continueButton(this.context, id, viewed)
            ],
          );
        });
  }

  deleteStory(String id, bool viewed) async {
    try {
      final SharedPreferences sharedref = await SharedPreferences.getInstance();
      String userId = sharedref.getString('userIDReference');
      String whereisIt = viewed == true ? 'Public' : 'Private';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('story')
          .doc(userId)
          .collection(whereisIt)
          .doc(id)
          .delete();
      fetchDatabaseList();
      ShowToast('Sucessfully Deleted');
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void createStory() {
    SharedPreferenceHelper().resetSharedPref();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CreateTitle()));
  }

  Widget buildStoriesList() {
    return ListView.builder(
      itemCount: userPublicStories.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
                          child: IconSlideAction(
                  caption: 'Edit',
                  color: Colors.blue,
                  icon: Icons.edit,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EditStory(userPublicStories[index], true)))),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
                          child: IconSlideAction(
                  caption: 'Delete',
                  color: Colors.indigo,
                  icon: Icons.delete_forever,
                  onTap: () {
                    String idpass = userPublicStories[index]['id'];
                    bool isPublic = userPublicStories[index]['viewed'];
                    showChoiceDialog(context, idpass, isPublic);
                  }),
            ),
          ],

          actionExtentRatio: 0.20,
          closeOnScroll: true,
          movementDuration: Duration(milliseconds: 200),
          child: Container(
            // color: HexColor('#FFFFFF'),
                      child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          InkWell(
                            onTap: (){
                            showImagePopUp(userPublicStories[index], context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            userPublicStories[index]['imageUrl']),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                userPublicStories[index]['title'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              )),
                        ],
                      ),
                      ListTile(
                        title: Text(
                          userPublicStories[index]['title'],
                          style: simpleStoriesTextStyle(),
                        ),
                        subtitle: Text(
                          userPublicStories[index]['date'],
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 15,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        leading: CircleAvatar(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset:
                                      Offset(0, 3), // changes position of shadow
                                )
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                userDetails['userImage']),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ViewPublicStory(userPublicStories[index])));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete', style: TextStyle(color: Colors.red)),
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
                    Navigator.pop(context, true);
                  }),
            ],
          );
        });
  }

  int _currentIndex = 0;
  Widget buildCarouselList() {
    return userPublicStories.isEmpty
        ? null
        : Container(
            color: Colors.white,
            child: CarouselSlider(
                options: CarouselOptions(
                  height: 150,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 2000),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: userPublicStories.map((imageurl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewPublicStory(imageurl)));
                        },
                        child: Container(
                          height: 150,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage(imageurl['imageUrl']),
                                fit: BoxFit.cover),
                          ),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  imageurl['title'],
                                  textAlign: TextAlign.center,
                                  style: carouselTextStyle(),
                                ),
                                Text(
                                  imageurl['date'],
                                  style: simpleTextStyle(),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList()),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? loadingScreen()
          : Container(
              // decoration: backgroundDecoration(),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Container(
                      child: userPublicStories.length > 0 ? Container() : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/blanknotebook.png',
                                    width: 50,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'No Story Yet.',
                                    style: simpleStoriesTextStyle(),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: buildStoriesList(),
                  ),
                ],
              ),
            ),
    );
  }
}
