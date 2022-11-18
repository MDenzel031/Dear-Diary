import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:deardiary/authenticate.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/notebook.png'), nextScreen: Authenticate(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.blueAccent,
      ),
      
    );
  }
}