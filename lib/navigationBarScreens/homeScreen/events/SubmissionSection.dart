import 'dart:io';

import 'package:else_app_two/basicElements/camera_impl.dart';
import 'package:else_app_two/basicElements/pick_gallery_impl.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/submission_confirmation_dialogue.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/submitted_view.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

class SubmissionSection extends StatefulWidget {
  final EventModel event;
  const SubmissionSection(this.event);
  @override
  SubmissionSectionState createState() => SubmissionSectionState();
}

class SubmissionSectionState extends State<SubmissionSection> {
  final logger = Logger();
  File imageFile;
  String imagePath = "still fetching asynchronously";
  int likes;
  String status;
  @override
  void initState() {
    DatabaseManager()
        .getUserSubmissionForEvent(widget.event)
        .then((submission) {
      if (submission != null) {
        setState(() {
          likes = submission.likes;
          imagePath = submission.imageUrl;
          status = submission.status;
        });
      } else {
        setState(() {
          imagePath = "never submitted";
        });
      }
    });
    super.initState();
  }

  onSubmissionConfirmedByUser(file) {
    setState(() {
      imageFile = file;
      status = "pending";
      likes = 0;
    });
    DatabaseManager()
        .addEventSubmission(widget.event, StartupData.userid, imageFile);
  }

  onImageSelectedFromCameraOrGallery(file) {
    logger.i(file);
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            SubmissionConfirmation(file, onSubmissionConfirmedByUser));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (imagePath.compareTo("still fetching asynchronously") == 0) {
      if (imageFile == null) {
        return Container(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
            child: Center(
              child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 60.0,
                  color: Colors.blue),
            ));
      } else {
        return AlreadySubmittedView(imageFile, status, likes);
      }
    } else if (imagePath.compareTo("never submitted") == 0) {
      if (imageFile == null) {
        return Container(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CameraImpl(onImageSelectedFromCameraOrGallery),
                  Container(
                      child: Text("Submit yours",
                          style: TextStyle(
                              fontSize: 13,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w400))),
                  GalleryImpl(onImageSelectedFromCameraOrGallery),
                ]));
      } else {
        return AlreadySubmittedView(imageFile, status, likes);
      }
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
                  child:
                      Image(fit: BoxFit.cover, image: NetworkImage(imagePath))),
              Column(children: <Widget>[Text(status)]),
            ],
          )));
    }
  }
}
