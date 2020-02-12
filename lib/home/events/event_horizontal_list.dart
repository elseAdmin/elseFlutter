import 'dart:ui';

import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/singleEvent/SingleEventPageViewHandler.dart';
import 'package:else_app_two/home/events/all_event_list_page.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logger/logger.dart';

class EventSection extends StatefulWidget {
  @override
  EventSectionState createState() => new EventSectionState();
}

class EventSectionState extends State<EventSection> {
  final logger = Logger();
  List<EventModel> events;
  final DatabaseManager manager = DatabaseManager();

  @override
  void initState() {
    super.initState();
    DatabaseManager.eventsFound = eventsFound;
    events = DatabaseManager.events;
  }

  eventsFound(List<EventModel> foundEvents) {
    setState(() {
      events = foundEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (events != null) {
      return Container(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1,
            bottom: SizeConfig.blockSizeVertical * 1,
          ),
          color: Constants.titleBarBackgroundColor,
          child: Column(
            children: <Widget>[
              Container(
                  padding:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
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
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Card(
                              shape: RoundedRectangleBorder(),
                              elevation: 2,
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
                                      CachedNetworkImage(
                                        colorBlendMode: BlendMode.luminosity,
                                        fit: BoxFit.cover,
                                        imageUrl: events[index].blurUrl,
                                      ),
                                      Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: SizeConfig
                                                      .blockSizeVertical,
                                                  left: SizeConfig
                                                          .blockSizeHorizontal *
                                                      2),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(events[index].name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 15)),
                                                  Text(events[index].type,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12))
                                                ],
                                              ))),
                                    ],
                                  ))),
                        );
                      }))
            ],
          ));
    } else {
      return Text("No events as such");
    }
  }
}
