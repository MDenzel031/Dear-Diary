import 'package:carousel_slider/carousel_slider.dart';
import 'package:deardiary/pages/setup/viewpublicstory.dart';
import 'package:deardiary/services/database.dart';
import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ViewUser extends StatefulWidget {
  String id;
  String userName;

  ViewUser(this.id, this.userName);

  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  List userStories;
  bool isLoading = false;

  _fetchUserStories() async {
    // final ref = await DataMethods().getUserDocFromTheId(widget.id);
    
    setState(() {
      isLoading = true;
    });

    dynamic ref = await DataMethods().getUsersStoriesById(widget.id);
    setState(() {
      
      userStories = ref;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserStories();
  }

  Widget buildStoriesList() {
    return ListView.builder(
      itemCount: userStories.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actions: <Widget>[
          ],
          child: Card(
            child: ListTile(
              title: Text(
                userStories[index]['title'],
                style: simpleStoriesTextStyle(),
              ),
              subtitle: Text(
                userStories[index]['date'],
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 15,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              leading: GestureDetector(
                onTap: (){
                  showImagePopUp(userStories[index], context);
                },
                              child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      )
                    ],
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(userStories[index]['imageUrl']),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewPublicStory(userStories[index])));
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildCarouselList() {
    return userStories.isEmpty
        ? null
        : Container(
            color: Colors.white,
            child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
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
                items: userStories.map((imageurl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: (){
                           Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewPublicStory(imageurl)));
                        },
                                              child: Container(
                          height: 150,
                          margin: EdgeInsets.all(2),
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
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: darkTheme(),
          ),
          title: Text('${widget.userName} Stories'),
          actions: [],
        ),
        body: isLoading == true
            ? Container(
                decoration: backgroundDecoration(),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                decoration: backgroundDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Container(
                        child: userStories.length > 0
                            ? buildCarouselList()
                            : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/blanknotebook.png',width: 50,),
                                  SizedBox(height: 5),
                                  Text('No Story Yet.',style: simpleStoriesTextStyle(),)
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
