import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/authenticate.dart';
import 'package:deardiary/pages/setup/HomePage.dart';
import 'package:deardiary/pages/setup/editUser.dart';
import 'package:deardiary/pages/setup/privatestorieshomepage.dart';
import 'package:deardiary/pages/setup/publicstorieshomepage.dart';
import 'package:deardiary/pages/setup/searchpeople.dart';
import 'package:deardiary/pages/setup/viewfollowing.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/toast.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String name = '';
  String email = '';
  String userImage =
      'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png';
  bool isLoading = false;

  nameHeader() async {
    var ref = await AuthMethods().getUser();
    try {
      if (true) {
        setState(() {
          name = ref['userName'];
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  emailHeader() async {
    var ref = await AuthMethods().getUser();
    if (ref != null) {
      email = ref['userEmail'];
    }
  }

  imageHeader() async {
    var ref = await AuthMethods().getUser();
    if (ref != null) {
      if (ref['userImage'].toString() != null) {
        setState(() {
          userImage = ref['userImage'];
        });
      }
    }
  }

  navigateEditUserDetails() async {
    setState(() {
      isLoading = true;
    });
    var ref = await AuthMethods().getUser();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => EditUser(ref)));

              setState(() {
        isLoading = false;
      });
  }

  _navigateStories(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomePage()));
  }

  _navigateViewFriends(){

  }

  _navigateSearch(){

  }

  @override
  void initState() {
    super.initState();
    nameHeader();
    emailHeader();
    imageHeader();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true ? Center(child: CircularProgressIndicator(),) :
    Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name, style: TextStyle(fontSize: 18, color: Colors.white)),
            accountEmail: Text(email,style: TextStyle(fontSize: 12, color: Colors.white)),
            currentAccountPicture: GestureDetector(
              onTap: navigateEditUserDetails,
            child: CircleAvatar(
                backgroundImage: NetworkImage(userImage),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://wallpaper.dog/large/5534026.jpg'),
                fit: BoxFit.fill
              )
            ),
          ),
          ListTile(
            title: Text('My Stories',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.public_outlined),
            subtitle: Text('View your stories',style: TextStyle(fontSize: 12)),
            onTap: _navigateStories,
          ),
          ListTile(
            title: Text('View Following',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.group_rounded),
            subtitle: Text('View stories of your friends',style: TextStyle(fontSize: 12)),
            onTap: (){
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewFollowing()));
            },
          ),
          ListTile(
            title: Text('Search',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.search_rounded),
            subtitle: Text('Follow people you know',style: TextStyle(fontSize: 12)),
            onTap: (){
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPeople()));
            },
            
          ),
          Divider(),
          ListTile(
            title: Text('Close',style: TextStyle(fontSize: 20)),
            trailing: Icon(Icons.close_rounded),
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            tileColor: Colors.redAccent,
            title: Text('Sign out',style: TextStyle(fontSize: 20,fontFamily: 'Lato',color: Colors.white)),
            trailing: Icon(Icons.exit_to_app,color: Colors.white),
            onTap: (){
              AuthMethods().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
            },
          ),
        ],
      ),
    );
}
}