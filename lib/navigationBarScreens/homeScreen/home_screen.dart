import 'package:else_app_two/basicElements/deal_horizontal_list.dart';
import 'package:else_app_two/feedback/FeedbackPage.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/event_horizontal_list.dart';
import 'package:else_app_two/requests/request_screen.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
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
                  DatabaseManager().getAllEventsForUser(StartupData.userid);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>  RequestsPage()));
                },
                child: Text(
                  "Requests",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: Constants.homePageHeadingsFontSize,
                  ),
                ))),
        Container(
            padding: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 1,
                left: SizeConfig.blockSizeHorizontal * 2),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>  FeedbacksPage()));
                },
                child: Text(
                  "Feedbacks",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: Constants.homePageHeadingsFontSize,
                  ),
                )))
      ],
    );
  }
}
