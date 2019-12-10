import 'package:else_app_two/home/deals/deal_horizontal_list.dart';
import 'package:else_app_two/feedback/FeedbackPage.dart';
import 'package:else_app_two/home/events/event_horizontal_list.dart';
import 'package:else_app_two/requests/request_screen.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return ListView(
      padding: const EdgeInsets.all(3),
      children: <Widget>[
        EventSection(),
        DealSection(),
        Container(
            padding: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 1,
                left: SizeConfig.blockSizeHorizontal * 2),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>  RequestsPage()));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Text(
                  "Requests",
                  style: TextStyle(
                    fontSize: Constants.homePageHeadingsFontSize,
                  ),
                ),
                    Divider(
                        endIndent: SizeConfig.blockSizeHorizontal * 60,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical)
                  ]))),
        Container(
            padding: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 1,
                left: SizeConfig.blockSizeHorizontal * 2,
            bottom: SizeConfig.blockSizeVertical*7),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>  FeedbacksPage()));
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(
                  "Feedbacks",
                  style: TextStyle(
                    fontSize: Constants.homePageHeadingsFontSize,
                  ),
                ),
                  Divider(
                      endIndent: SizeConfig.blockSizeHorizontal * 60,
                      color: Colors.black87,
                      height: SizeConfig.blockSizeVertical)
                ])
            ))
      ],
    );
  }
}
