import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbacksPage extends StatefulWidget {
  @override
  FeedbacksPageState createState() => FeedbacksPageState();
}

class FeedbacksPageState extends State<FeedbacksPage> {
  final subjectController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.textColor),
        backgroundColor: Constants.titleBarBackgroundColor,
        title: Text(
          "Feedbacks",
          style: TextStyle(
            color: Constants.titleBarTextColor,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(children: <Widget>[
        Container(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 3,
                right: SizeConfig.blockSizeHorizontal * 3),
            child: TextField(
              controller: subjectController,
              keyboardType: TextInputType.text,
            )),
        Container(
            padding: EdgeInsets.only(
               // left: SizeConfig.blockSizeHorizontal * 3,
                right: SizeConfig.blockSizeHorizontal * 3),
            child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: <Widget>[
              Radio(value: 1, groupValue: null, onChanged: null),
              Text("Positive"),
            ]),
            Row(
              children: <Widget>[
                Radio(value: 1, groupValue: null, onChanged: null),
                Text("Negetive")
              ],
            )
          ],
        ))
      ]),
    );
  }
}
