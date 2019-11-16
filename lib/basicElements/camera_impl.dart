import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class CameraImpl extends StatefulWidget{
  CameraImplState cameraImplState = CameraImplState();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return cameraImplState;
  }
}
class CameraImplState extends State<CameraImpl>{
  final logger = Logger();
  File imageClicked;
  Future<void> renderSuitableCameraView() {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: handleState("camera"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: handleState("gallery"),
                  ),
                ],
              ),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    File getLatestPickedImageFile(){
      return imageClicked;
    }
    if(imageClicked==null) {
      return FloatingActionButton(
        onPressed: renderSuitableCameraView,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      );
    }else{
      return Column(
        children: <Widget>[
          Image.file(imageClicked),
          FloatingActionButton(
            onPressed: renderSuitableCameraView,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
            ),
        ],
      );
    }
  }

  handleState(String source){
    if(source.compareTo("gallery")==0) {
      openGallery().then((filepath) {
        changeState(filepath);
      }).catchError((error){logger.e("Error with open gallery Future in camera impl "+error);});
    }else if(source.compareTo("camera")==0) {
      openCamera().then((filePath) {
        changeState(filePath);
      }).catchError((error){logger.e("Error in open camera Future in ccamera impl "+error);});
    }
  }

  Future<File> openCamera() async{
    return await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
  }
  Future<File> openGallery() async{
    return await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
  }

  changeState(File file) {
    logger.i("File path : "+file.path);
    setState(() {
      imageClicked=file;
    });
  }


}