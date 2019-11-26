import 'dart:io';

import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class AlreadySubmittedView extends StatelessWidget{
  File imageFile;
  String status;
  int likes;
  AlreadySubmittedView( File imageFile,
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
            top: SizeConfig.blockSizeVertical * 2,
            left: SizeConfig.blockSizeHorizontal * 2),
        child: (Row(
          children: <Widget>[
            Container(
                width: SizeConfig.blockSizeHorizontal * 50,
                height: SizeConfig.blockSizeVertical * 30,
                child:
                Image(fit: BoxFit.cover, image: FileImage(imageFile))),
            Column(
              children: <Widget>[Text(status)],
            )
          ],
        )));;
  }

}