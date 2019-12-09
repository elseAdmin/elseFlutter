import 'dart:io';

import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class JustSubmittedView extends StatelessWidget{
  File imageFile;
  String status;
  int likes;
  JustSubmittedView( File imageFile,
  String status,
  int likes){
    this.imageFile=imageFile;
    this.status=status;
    this.likes=likes;
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init;
    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 2),
        child: (Column(
          children: <Widget>[
            Container(
                width: SizeConfig.blockSizeHorizontal * 80,
                height: SizeConfig.blockSizeVertical * 28,
                child:
                Image(fit: BoxFit.cover, image: FileImage(imageFile))),
            Column(
              children: <Widget>[Text("uploading ..")],

            )
          ],
        )));
  }

}