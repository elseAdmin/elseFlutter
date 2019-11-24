import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class GalleryImpl extends StatefulWidget {
  @override
  GalleryImplState createState() => new GalleryImplState();
}

class GalleryImplState extends State<GalleryImpl> {
  final logger = Logger();
  File imageClicked;
  Future<void> renderSuitableCameraView() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[

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
    return GestureDetector(
        onTap: () {
          renderSuitableCameraView();
        },
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Icon(Icons.add_a_photo)]));
  }

  handleState(String source) {
    if (source.compareTo("gallery") == 0) {
      logger.i("insdie gallery");
      openGallery().then((filepath) {
        changeState(filepath);
      }).catchError((error) {
        logger.e("Error with open gallery Future in camera impl " + error.toString());
      });
    } else if (source.compareTo("camera") == 0) {
      logger.i("insdie camera");
      openCamera().then((filePath) {
        changeState(filePath);
      }).catchError((error) {
        logger.e("Error in open camera Future in camera impl " + error.toString());
      });
    }
  }

  Future openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
  }

  Future openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  changeState(File file) {
    logger.i("File path : " + file.path);
    setState(() {
      imageClicked = file;
    });
  }
}
