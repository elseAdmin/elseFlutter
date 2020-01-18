import 'dart:io';

import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class JustSubmittedView extends StatefulWidget {
  final File imageFile;
  final String status;
  final int likes;
  JustSubmittedView(this.imageFile, this.status, this.likes);
  @override
  createState() => JustSubmittedViewState();
}

class JustSubmittedViewState extends State<JustSubmittedView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
        child: (Column(
          children: <Widget>[
            Container(
                width: SizeConfig.blockSizeHorizontal * 80,
                height: SizeConfig.blockSizeVertical * 28,
                child: Image(
                    fit: BoxFit.cover, image: FileImage(widget.imageFile))),
            Column(
              children: <Widget>[Text(widget.status)],
            )
          ],
        )));
  }
}
