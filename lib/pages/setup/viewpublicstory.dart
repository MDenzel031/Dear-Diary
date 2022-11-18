import 'package:deardiary/widget.dart';
import 'package:flutter/material.dart';

class ViewPublicStory extends StatelessWidget {
  dynamic story;

  ViewPublicStory(this.story);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(story['title']),
            pinned: true,
            expandedHeight: 500.0,
            floating: true,
            backgroundColor: Colors.white30,
            flexibleSpace: FlexibleSpaceBar(

              background: GestureDetector(
                onTap: (){
                  showImagePopUp(story, context);
                },
                child: Image.network(
                  story['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 100.0,
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white30,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Story Title:',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Lato',
                        ),
                      ),
                      Text(
                        story['title'],
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Lato',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          SliverFixedExtentList(
            itemExtent: 500.0,
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white30,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Lato',
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            story['detail'],
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
