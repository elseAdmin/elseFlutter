import 'dart:ui';

import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/singleEvent/SingleEventPageViewHandler.dart';
import 'package:else_app_two/home/events/all_event_list_page.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';

class EventSection extends StatefulWidget {
  @override
  EventSectionState createState() => new EventSectionState();
}

class EventSectionState extends State<EventSection> {
  final logger = Logger();
  List<EventModel> events = new List();
  final DatabaseManager manager = DatabaseManager();
  List<EventModel> events2 = new List();

  @override
  void initState() {
    super.initState();
    manager.getEventsDBRef().onChildAdded.listen(_newEventAdded);
  }

  void _newEventAdded(Event e) {
    EventModel newEvent = new EventModel(e.snapshot);
    if (newEvent.status == 'active') {
      setState(() {
        events.add(newEvent);
      });
    } else if (newEvent.status == 'inactive') {
      if (events.contains(newEvent)) {
        setState(() {
          events.remove(newEvent);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 1,
                left: SizeConfig.blockSizeHorizontal * 2),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EventListPage(events)));
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Events",
                      style: TextStyle(
                        fontSize: Constants.homePageHeadingsFontSize,
                      ),
                    ),
                    Divider(
                        endIndent: SizeConfig.blockSizeHorizontal * 60,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical)
                  ]),
            )),
        Container(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 1,
                right: SizeConfig.blockSizeHorizontal * 1),
            height: MediaQuery.of(context).size.height * 0.30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Constants.mainBackgroundColor,
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Card(
                        color: Constants.mainBackgroundColor,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SingleEventPageViewHandler()
                                              .getViewAccordingToEventType(
                                                  events[index])));
                            },
                            child: Stack(
                              fit: StackFit.passthrough,
                              children: <Widget>[
                                Opacity(
                                    opacity: 0.6,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: events[index].blurUrl,
                                    )),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(events[index].name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20))),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                SizeConfig.blockSizeVertical,
                                            right:
                                                SizeConfig.blockSizeHorizontal *
                                                    2),
                                        child: Text(events[index].type,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13)))),
                              ],
                            ))),
                  );
                }))
      ],
    );
  }
}
