import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/viewotheruserprofile.dart';
import 'package:deardiary/pages/setup/viewuser.dart';
import 'package:deardiary/services/database.dart';
import 'package:deardiary/toast.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewFollowing extends StatefulWidget {
  @override
  _ViewFollowingState createState() => _ViewFollowingState();
}

class _ViewFollowingState extends State<ViewFollowing> {
  final searchController = TextEditingController();
  bool isLoading = false;
  DataMethods datamethods = DataMethods();
  QuerySnapshot searchSnapShot;
  DocumentReference searchUser;
  List friendslist = [];
  List searchResult = [];

  Widget searchList() {
    return searchResult.length > 0
        ? isLoading == true
            ? Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Text(
                    'Search Result',
                    style: simpleStoriesTextStyle(),
                  ),
                  ListView.builder(
                    itemCount: searchResult.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            viewUserProfile(searchResult[index]['userId'],searchResult[index]['userName']);
                            ShowToast('Search Reach');
                          },
                          child: ListTile(
                            title: Text(searchResult[index]['userName']),
                            subtitle: Text(searchResult[index]['userEmail']),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  searchResult[index]['userImage']),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                showChoiceDialog(
                                    context, searchResult[index]['userId']);
                              },
                              child: Icon(Icons.person_remove_rounded),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              )
        : Container();
  }

  _displayFriends() async {
    final pref = await SharedPreferences.getInstance();
    String uid = pref.getString('userIDReference');
    DocumentSnapshot friends =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    friendslist = await List.from(friends['userFriends']);

    List<dynamic> temp = [];

    for (var i in friendslist) {
      String friendId = i;
      DocumentSnapshot friend = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .get();
      Map<String, dynamic> tempData = {
        'userName': friend['userName'],
        'userEmail': friend['userEmail'],
        'userImage': friend['userImage'],
        'userId': friend.id,

      };
      try{
        tempData.putIfAbsent('userDescription', () => friend['userDescription']);
      }catch(e){
        tempData.putIfAbsent('userDescription', () => 'No description');
      }
      
      temp.add(tempData);
      print(i);
    }

    setState(() {
      friendslist = temp;
    });
  }

  void initiateSearch() async {
    List getUsers = [];
    if (friendslist.length > 0) {
      for (var i in friendslist) {
        if (i['userName'].toString().toLowerCase() == searchController.text.toLowerCase()) {
          getUsers.add(i);
          print(i);
        }
      }
    }

    setState(() {
      searchResult = getUsers;
    });
  }

  _removeFriendFromFirebase(String userId) async {
    setState(() {
      isLoading = true;
    });
    final docReference = await DataMethods().getUserDocFromUsers();
    // DocumentSnapshot docSnapshot = await docReference.get();

    await docReference.update({
      'userFriends': FieldValue.arrayRemove([userId])
    });
    _displayFriends();
    setState(() {
      isLoading = false;
    });
  }

  Widget cancelButton(BuildContext context) {
    return FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(this.context).pop();
      },
    );
  }

  Widget continueButton(BuildContext context, String uid) {
    return FlatButton(
      child: Text("Yes"),
      onPressed: () {
        _removeFriendFromFirebase(uid);
        _reload();
        Navigator.of(this.context).pop();
      },
    );
  }

  Future<void> showChoiceDialog(BuildContext context, String uid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warning!', style: TextStyle(color: Colors.red)),
            content: Text('are you sure you want to unfriend this person?'),
            actions: [cancelButton(context), continueButton(this.context, uid)],
          );
        });
  }

  viewUserProfile(String id, String userName) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ViewUser(id,userName)));
  }

  _removeFriend(String email) {}
  @override
  void initState() {
    super.initState();
    _displayFriends();
  }

  Widget _buildFriendsList() {
    return Expanded(
      child: ListView.builder(
          itemCount: friendslist.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        // ViewUser(friendslist[index]['userId'],friendslist[index]['userName'])));
                        ViewOtherUserProfile(friendslist[index])));
              },
              child: Card(
                child: ListTile(
                  title: Text(friendslist[index]['userName']),
                  subtitle: Text(friendslist[index]['userEmail']),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(friendslist[index]['userImage']),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      showChoiceDialog(context, friendslist[index]['userId']);
                    },
                    child: Icon(Icons.person_remove_rounded),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _reload() {
    if (searchResult.length > 0) {
      setState(() {
        searchResult.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
        flexibleSpace: Container(
          decoration: darkTheme(),
        ),
        actions: [
          GestureDetector(
            onTap: _reload,
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.refresh_rounded),
            ),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: (){
          // onBackPressed(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainHomePage()));
        },
              child: SingleChildScrollView(
                child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                searchList(),
                Divider(),
                Text(
                  'Following List',
                  style: simpleStoriesTextStyle(),
                ),
                friendslist.length != null
                    ? isLoading == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _buildFriendsList()
                    : Center(
                        child: Text(
                          'No following yet',
                          style: simpleTextStyle(),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
