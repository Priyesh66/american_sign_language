import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:american_sign_language/MySplashScreen.dart';
List <CameraDescription> cameras;
Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASL',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
        home:MySplashScreen()

    );
  }
}


