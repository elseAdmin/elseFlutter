import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class CameraImpl extends StatefulWidget {
  final Function(File) callback;
  const CameraImpl(this.callback);
  @override
  CameraImplState createState() => new CameraImplState();
}

class CameraImplState extends State<CameraImpl> {
  final logger = Logger();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          getImage();
        },
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Icon(Icons.add_a_photo)]));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 25);

    widget.callback(image);
  }
}
