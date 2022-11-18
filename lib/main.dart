import 'package:deardiary/authenticate.dart';
import 'package:deardiary/pages/setup/signin.dart';
import 'package:deardiary/pages/setup/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dear Diary",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145c9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
      ),
      home: Authenticate(),
    );
  }
}
