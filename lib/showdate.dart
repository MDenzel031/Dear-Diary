import 'package:deardiary/widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ShowDate extends StatefulWidget {


  @override
  ShowDateState createState() => ShowDateState();
}

class ShowDateState extends State<ShowDate> {
  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '${now}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.white60,
        ),
      ),
    );
  }
}
