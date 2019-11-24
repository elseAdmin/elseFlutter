import 'dart:io';

import 'package:else_app_two/basicElements/camera_impl.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SubmissionSection extends StatefulWidget {
  final EventModel event;
  const SubmissionSection(this.event);
  @override
  SubmissionSectionState createState() => SubmissionSectionState();
}

class SubmissionSectionState extends State<SubmissionSection> {
  final logger = Logger();
  File imageFile;
  callback(file) {
    logger.i(file);
    setState(() {
      imageFile = file;
    });
    DatabaseManager().addEventSubmission(widget.event, "123", imageFile);
    //upload to firestore
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    if (imageFile == null) {
      return Container(
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CameraImpl(callback),
                Container(
                    child: Text("Submit yours",
                        style: TextStyle(
                            fontSize: 13,
                            color: Constants.textColor,
                            fontWeight: FontWeight.w400))),
                GestureDetector(onTap: () {}, child: Icon(Icons.photo_album)),
              ]));
    } else {
      return Container(
          padding: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 2,
              left: SizeConfig.blockSizeHorizontal * 2),
          child: (Row(
            children: <Widget>[
              Container(
                  width: SizeConfig.blockSizeHorizontal * 50,
                  height: SizeConfig.blockSizeVertical * 30,
                  child: Image(fit: BoxFit.cover, image: FileImage(imageFile)))
            ],
          )));
    }
  }
}
