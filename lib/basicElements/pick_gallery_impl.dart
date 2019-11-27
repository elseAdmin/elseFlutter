import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class GalleryImpl extends StatefulWidget {
  final Function(File) callback;
  const GalleryImpl(this.callback);
  @override
  GalleryImplState createState() => new GalleryImplState();
}

class GalleryImplState extends State<GalleryImpl> {
  final logger = Logger();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          getImage();
        },
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Icon(Icons.photo_library)]));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 25);

    widget.callback(image);
  }
}
