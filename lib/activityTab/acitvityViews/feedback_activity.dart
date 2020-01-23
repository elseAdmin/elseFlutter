import 'package:else_app_two/feedback/models/user_feedback_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class FeedbackActivity extends StatelessWidget{
  final UserFeedBack feedBack;
  FeedbackActivity(this.feedBack);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*1,left: SizeConfig.blockSizeHorizontal),
        child: GestureDetector(
            onTap: () => {

            },
            child: Text("You have submitted a feedback at " + feedBack.universe)));
  }

}