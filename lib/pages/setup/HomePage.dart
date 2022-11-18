import 'package:deardiary/pages/maindrawer.dart';
import 'package:deardiary/pages/setup/allpagecontainer.dart';
import 'package:deardiary/pages/setup/creatingstory/creatingtitle.dart';
import 'package:deardiary/pages/setup/editUser.dart';
import 'package:deardiary/pages/setup/privatestorieshomepage.dart';
import 'package:deardiary/pages/setup/publicstorieshomepage.dart';
import 'package:deardiary/pages/setup/searchpeople.dart';
import 'package:deardiary/pages/setup/viewfollowing.dart';
import 'package:deardiary/pages/setup/viewuserprofile.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/services/sharedpreferencehelper.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [
    HomePage(),
    ViewFollowing(),
    SearchPeople(),
  ];

  dynamic ref;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _getUserReference() async {
    dynamic data = await AuthMethods().getUser();
    setState(() {
      ref = data;
    });
  }

  void createStory() {
    SharedPreferenceHelper().resetSharedPref();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CreateTitle()));
  }

  // Future<bool> _onBackPressed() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Delete', style: TextStyle(color: Colors.red)),
  //           content: Text('Are you sure you want this exit?'),
  //           actions: [
  //             FlatButton(
  //               child: Text('No'),
  //               onPressed: () {
  //                 Navigator.pop(context, false);
  //               },
  //             ),
  //             FlatButton(
  //                 child: Text('Yes'),
  //                 onPressed: () {
  //                   Navigator.pop(context, true);
  //                 }),
  //           ],
  //         );
  //       });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserReference();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onBackPressed(context);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: darkTheme(),
            ),
            elevation: 5,
            leading: Container(
              alignment: Alignment.centerRight,
              child: ref != null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditUser(ref)));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(ref['userImage']),
                      ),
                    )
                  : CircleAvatar(),
            ),
            title: ref != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref['userName'].toString(),
                        style: TextStyle(
                            letterSpacing: 1.2,
                            fontSize: 20,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ref['userEmail'].toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(letterSpacing: 1.2, fontSize: 10),
                      ),
                    ],
                  )
                : Text('Unknown'),
            leadingWidth: 55,
            toolbarHeight: 130,
            actions: [
              GestureDetector(
                onTap: () {
                  showChoiceDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.exit_to_app),
                ),
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: [
                Tab(
                  icon: Icon(Icons.public_outlined),
                  text: 'Public Stories',
                ),
                Tab(
                  icon: Icon(Icons.lock_outline),
                  text: 'Private Stories',
                ),
              ],
            ),
          ),
          // drawer: MainDrawer(),
          floatingActionButton: FloatingActionButton(
            child: Container(
              width: 60,
              height: 60,
              child: Icon(Icons.add_a_photo),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white30,
                    Colors.white30,
                  ],
                ),
              ),
            ),
            onPressed: createStory,
          ),
          body: TabBarView(
            children: [
              PublicHomePage(),
              PrivateHomePage(),
            ],
          ),
        ),
      ),
    );
  }
}
