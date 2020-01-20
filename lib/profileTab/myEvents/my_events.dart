import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/base_model.dart';
import 'package:else_app_two/profileTab/myEvents/my_event_card.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (details != null) {
      if(details.isEmpty){
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
            body: Center(
              child:Text("You have not participated in any event till now"),
            ));
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
          body: Container(
            color:Colors.white,
              child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2,
                            left: SizeConfig.blockSizeHorizontal * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Total events participated : " +
                                  details.length.toString(),
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        )),
                    Divider(
                        indent: SizeConfig.blockSizeHorizontal * 7,
                        endIndent: SizeConfig.blockSizeHorizontal * 7,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical * 5)
                  ],
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return MyEventCard(details[index]);
              }, childCount: details.length)),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Divider(
                        indent: SizeConfig.blockSizeHorizontal * 7,
                        endIndent: SizeConfig.blockSizeHorizontal * 7,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical * 5),
                    Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                      Text("Else",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),)
                    ],)
                  ],
                ),
              )
            ],
          )));
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
        body: Center(
          child: Loading(
              indicator: BallPulseIndicator(), size: 60.0, color: Colors.blue),
        ));
  }
}
