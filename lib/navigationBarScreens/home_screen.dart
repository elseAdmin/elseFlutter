import 'package:else_app_two/feedback/new_feedback.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/deals/deal_horizontal_list.dart';
import 'package:else_app_two/home/events/event_horizontal_list.dart';
import 'package:else_app_two/home/events/feedback_section.dart';
import 'package:else_app_two/home/request_section.dart';
import 'package:else_app_two/requests/request_screen.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool refresh = false;
  Future<Null> _handleRefresh() async {
    DatabaseManager().refreshEventsAndDeals(onRefresh);
    return null;
  }
  onRefresh(){
    setState(() {
      refresh = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          padding: const EdgeInsets.all(3),
          children: <Widget>[
            EventSection(),
            DealSection(),
            RequestSection(),
            FeedbackSection()
          ],
        ));
  }
}
