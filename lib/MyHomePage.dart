import 'package:american_sign_language/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  bool isWorking = false;
  String result = "";
  CameraController cameraController;
  CameraImage imgCamera;
  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFrontStream) =>
        {
          if(!isWorking)
            {
              isWorking = true,
              imgCamera = imageFrontStream,
              runModelOnStreamFrames(),
            }
        });
      });
    });

  }
  runModelOnStreamFrames() async{

    if(imgCamera !=null)
      {
        var recognitions = await Tflite.runModelOnFrame(
            bytesList: imgCamera.planes.map((plane) {return plane.bytes;}).toList(),// required
            imageHeight: imgCamera.height,
            imageWidth: imgCamera.width,
            imageMean: 127.5,
            imageStd: 127.5,
            rotation: 90,
            numResults: 2,
            threshold: 0.1,
            asynch: true
        );
        result = "";
        recognitions.forEach((response) {
          result += response["label"] +"  " +(response["confidence"] as double).toStringAsFixed(2)+"\n\n";

        });

        setState(() {
          result;
        });
        isWorking = false;
      }
  }


  loadModel() async
  {
    await Tflite.loadModel(
      model: "assets/mobilenet_2.tflite",
      labels: "assets/labels.txt",
    );
  }
  @override
  void initState(){
    super.initState();
    loadModel();
  }
  @override
  void dispose() async{
    super.dispose();
    await Tflite.close();
    cameraController?.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Center(child: FlatButton(onPressed: (){
                  initCamera();
                }, child: Container(margin: EdgeInsets.only(top:35),
                height: 270,
                    width:300,
                    child:imgCamera==null
                  ?Container(height: 270,
                        width: 360,
                        child:Icon(Icons.photo_camera,color:Colors.blueAccent,size:40,))
                        :AspectRatio(aspectRatio: cameraController.value.aspectRatio,
                    child:CameraPreview(cameraController),
                    )
                  ,)),)
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 55.0),
                child: SingleChildScrollView(
                  child: Text(result,
                  style:TextStyle(backgroundColor: Colors.black87,
                  fontSize: 25.0,
                  color: Colors.white,) ,
                  textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),

      ),

    );
  }
}
