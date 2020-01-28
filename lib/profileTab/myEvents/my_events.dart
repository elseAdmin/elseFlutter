import 'package:else_app_two/basicElements/BallProgressIndicator.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/base_model.dart';
import 'package:else_app_two/profileTab/myEvents/my_event_view_handler.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyEvents extends StatefulWidget {
  @override
  createState() => MyEventState();
}

class MyEventState extends State<MyEvents> {
  List<Map<String, BaseModel>> details;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    details = DatabaseManager.myEvents;
  }
  Future<Null> _handleRefresh() async {
   DatabaseManager().getAllEventsForUser(true).then((myEvents){
     setState(() {
       details=myEvents;
     });
   });
    return null;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (details != null) {
      return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Scaffold(
              backgroundColor: Constants.mainBackgroundColor,
              appBar: AppBar(
                backgroundColor: Constants.titleBarBackgroundColor,
                iconTheme: IconThemeData(
                  color: Constants.textColor, //change your color here
                ),
                title: Text(
                  "My Events",
                  style: TextStyle(
                    color: Constants.titleBarTextColor,
                    fontSize: 18,
                  ),
                ),
              ),
              body: MyEventViewHandler().getAppropriateView(details)));
    }
    return Scaffold(
        backgroundColor: Constants.mainBackgroundColor,
        appBar: AppBar(
          backgroundColor: Constants.titleBarBackgroundColor,
          iconTheme: IconThemeData(
            color: Constants.textColor, //change your color here
          ),
          title: Text(
            "My Events",
            style: TextStyle(
              color: Constants.titleBarTextColor,
              fontSize: 18,
            ),
          ),
        ),
        body: BallProgressIndicator());
  }
}
