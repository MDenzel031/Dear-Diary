import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/viewotheruserprofile.dart';
import 'package:deardiary/pages/setup/viewuser.dart';
import 'package:deardiary/services/database.dart';
import 'package:deardiary/services/sharedpreferencehelper.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPeople extends StatefulWidget {
  @override
  _SearchPeopleState createState() => _SearchPeopleState();
}

class _SearchPeopleState extends State<SearchPeople> {
  DataMethods datamethods = DataMethods();
  TextEditingController searchController = TextEditingController();
  QuerySnapshot searchSnapShot;
  Map<String, String> theDocument;
  List<dynamic> usernameResults = [];
  DocumentReference searchUser;
  bool isLoading = false;

  initiateSearch() async {
    setState(() {
      isLoading = true;
    });
    datamethods.getUserByUsername(searchController.text).then((value) {
      setState(() {
        searchSnapShot = value;
        isLoading = false;
      });
    });

    ShowToast(searchSnapShot.docs[0].get('userName'));
  }

  _getDocumentReference(String userId) async {
    final pref = await SharedPreferences.getInstance();

    searchUser = await DataMethods().getUserDocFromUsers();
    DocumentSnapshot documentSnapshot = await searchUser.get();

    // searchUser.update({
    //   'userFriends': FieldValue.arrayUnion([userId])
    // });

    try {
      List tags = documentSnapshot.get('userFriends');

      if (tags.contains(userId) == true) {
        ShowToast('Already in Friends List');
      } else if (userId == pref.getString('userIDReference')) {
        ShowToast('This is you silly');
      } else {
        searchUser.update({
          'userFriends': FieldValue.arrayUnion([userId])
        });
        ShowToast('Sucessfully Added');
      }
    } catch (e) {
      searchUser.update({
        'userFriends': FieldValue.arrayUnion([userId])
      });
      ShowToast('Sucessfully Added');
    }
  }

  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(this.context).pop();
      },
    );
  }

  Widget continueButton(BuildContext context, String userId) {
    return FlatButton(
      child: Text("Yes"),
      onPressed: () {
        _getDocumentReference(userId);
        Navigator.of(this.context).pop();
      },
    );
  }

  Future<void> showChoiceDialog(BuildContext context, String email) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Follow', style: TextStyle(color: Colors.red)),
            content: Text('Add this user to your Following list?'),
            actions: [
              cancelButton(context),
              continueButton(this.context, email)
            ],
          );
        });
  }

  Widget searchList() {
    return searchSnapShot != null && searchSnapShot.size > 0
        ? isLoading == true
            ? Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                itemCount: searchSnapShot.size,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // viewUserProfile(searchSnapShot.docs[index].id,
                        //     searchSnapShot.docs[index]['userName']);
                        var otherUserDetails = searchSnapShot.docs[index].data();
                        otherUserDetails.putIfAbsent('userDescription', () => 'No description');
                        otherUserDetails.putIfAbsent('userId', () => searchSnapShot.docs[index].id);

                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewOtherUserProfile(otherUserDetails)));
                      },
                      child: ListTile(
                        title: Text(searchSnapShot.docs[index].get('userName')),
                        subtitle:
                            Text(searchSnapShot.docs[index].get('userEmail')),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              searchSnapShot.docs[index].get('userImage')),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            String userId = searchSnapShot.docs[index].id;
                            showChoiceDialog(context, userId);
                          },
                          child: Icon(Icons.person_add),
                        ),
                      ),
                    ),
                  );
                },
              )
        : Container(
            child: Text(
              'Nothing Found',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Lato',
              ),
            ),
          );
  }

  viewUserProfile(String id, String userName) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ViewUser(id, userName)));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search People'),
        flexibleSpace: Container(
          decoration: darkTheme(),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          // onBackPressed(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainHomePage()));
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  // color: Color(0x54FFFFFF),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search Username',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          initiateSearch();
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF)
                              ]),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(Icons.search_rounded)),
                      )
                    ],
                  ),
                ),
                searchSnapShot != null
                    ? searchList()
                    : Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/blanknotebook.png',
                              width: 50,
                            ),
                            Text(
                              'Search Someone',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Lato',
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
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;

  SearchTile({this.userName, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                userName,
                style: simpleTextStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: Colors.blue),
              child: Text('Message'),
            ),
          ),
        ],
      ),
    );
  }
}
