import 'package:american_sign_language/MyHomePage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds:10,
      navigateAfterSeconds: MyHomePage(),
      title:Text('American Sign Language',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),loaderColor: Colors.white,loadingText:Text('Loading') ,
    );
  }
}
