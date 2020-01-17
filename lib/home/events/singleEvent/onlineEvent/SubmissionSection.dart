import 'dart:io';

import 'package:else_app_two/basicElements/camera_impl.dart';
import 'package:else_app_two/basicElements/pick_gallery_impl.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/singleEvent/onlineEvent/past_submission_view.dart';
import 'package:else_app_two/home/events/singleEvent/onlineEvent/submission_confirmation_dialogue.dart';
import 'package:else_app_two/home/events/singleEvent/onlineEvent/just_submitted_view.dart';
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
  bool isLoggedIn;
  final logger = Logger();
  File imageFile;
  String imagePath = "still fetching asynchronously";
  int likes;
  String status;

  @override
  void initState() {
    if (StartupData.user != null) {
      isLoggedIn = true;
      DatabaseManager()
          .getUserSubmissionForOnlineEvent(widget.event)
          .then((submission) {
        if (submission != null) {
          setState(() {
            likes = submission.likes;
            imagePath = submission.imageUrl;
            status = submission.status;
          });
        } else {
          setState(() {
            //user has no submission for event
            imagePath = "never submitted";
          });
        }
      });
    } else {
      isLoggedIn = false;
    }
    super.initState();
  }

  void _signedIn() {
    DatabaseManager()
        .getUserSubmissionForOnlineEvent(widget.event)
        .then((submission) {
      if (submission != null) {
        setState(() {
          likes = submission.likes;
          imagePath = submission.imageUrl;
          status = submission.status;
        });
      } else {
        setState(() {
          //user has no submission for event
          isLoggedIn = true;
          imagePath = "never submitted";
        });
      }
    });
  }

  onSubmissionConfirmedByUser(file) {
    setState(() {
      imageFile = file;
      status = "pending";
      likes = 0;
    });

    DatabaseManager()
        .markUserParticipationForOnlineEvent(
            widget.event, StartupData.user.id, imageFile)
        .then((status) {
      if (status.compareTo("Submission upload sucess") == 0) {
        setState(() {
          status = "uploaded";
        });
      }
    });
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
    if (isLoggedIn) {
      if (imagePath.compareTo("still fetching asynchronously") == 0) {
        //we are still fetching image from firebase in init method and on the same time this build method was called
        if (imageFile == null) {
          //we are not building this widget just after the user clicked or picked an image from gallery instead this widget is building at some time in future.
          //so you return the loader and wait for this data from firestore to be fetched
          return Container(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
              child: Center(
                child: Loading(
                    indicator: BallPulseIndicator(),
                    size: 50.0,
                    color: Colors.blue),
              ));
        } else {
          // the user has just clicked or picked an image from the gallery so we re-render that image first and then we upload submission data to firestore
          return JustSubmittedView(imageFile, status, likes);
        }
      } else if (imagePath.compareTo("never submitted") == 0) {
        // user has no submission for this event
        if (imageFile == null) {
          //nor the image was just picked from the camera or gallery so we return the "submit yours" UI
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
          //user just clicked an image or picked from gallery and now that re-renders immediately without waiting for submission data to upload to complete
          return JustSubmittedView(imageFile, status, likes);
        }
      } else {
        // user has a submission submitted in the past
        return PastSubmissionView(imagePath, status);
      }
    } else {
      return Center(
          child: GestureDetector(onTap: redirectLogin, child: Text("Login")));
    }
  }

  redirectLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OauthManager(onSignedIn: _signedIn),
      ),
    );
  }
}
