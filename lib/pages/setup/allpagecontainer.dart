import 'package:deardiary/pages/setup/HomePage.dart';
import 'package:deardiary/pages/setup/editUser.dart';
import 'package:deardiary/pages/setup/searchpeople.dart';
import 'package:deardiary/pages/setup/viewfollowing.dart';
import 'package:deardiary/pages/setup/viewuserprofile.dart';
import 'package:deardiary/services/auth.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  int selectedIndex = 0;
  @override
  MainHomePageState createState() => MainHomePageState();
}

class MainHomePageState extends State<MainHomePage> {

  
List<Widget> _widgetOptions = [
  HomePage(),
  ViewFollowing(),
  SearchPeople(),
];

void _onItemTap(int index){
  setState(() {
    widget.selectedIndex = index;
  });
}


  navigateEditUserDetails() async {
    var ref = await AuthMethods().getUser();
    _widgetOptions.add(ViewUserProfile(ref));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateEditUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(widget.selectedIndex),
      bottomNavigationBar: Container(
              decoration: darkTheme(),
              child: BottomNavigationBar(
                elevation: 0,
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.blueAccent,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.public),
                  label: "Stories",
                  
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_compact),
                  label: "Following",
                  
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Search",
                  
                ),
                BottomNavigationBarItem(
                  
                  icon: Icon(Icons.person),
                  label: "Me",

                  
                ),
                
              ],
              currentIndex: widget.selectedIndex,
              onTap: (index){
                _onItemTap(index);
              },
            ),
      ),
    );
  }
}