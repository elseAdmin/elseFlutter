import 'package:else_app_two/feedback/new_feedback.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class FeedbackSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(SizeConfig.blockSizeVertical * 2),
        child: GestureDetector(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: SizeConfig.blockSizeHorizontal),
              color: Constants.titleBarBackgroundColor,
              child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.feedback,
                      size: 35,
                      color: Constants.navBarButton,
                    ),
                    Text(
                      'Feedback',
                      style: TextStyle(fontSize: 18,color: Constants.navBarButton),
                    )
                  ]),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          NewFeedBack()));
            }));
  }
}
