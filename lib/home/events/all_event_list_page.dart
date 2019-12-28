import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

import 'singleEvent/SingleEventPageViewHandler.dart';

class EventListPage extends StatelessWidget {
  List<EventModel> events;
  List<EventModel> onlineEvents;
  List<EventModel> offlineEvents;
  List<EventModel> locationEvents;
  EventListPage(List<EventModel> events) {
    this.events = events;
    onlineEvents = List();
    offlineEvents = List();
    locationEvents = List();
    for (EventModel event in events) {
      if (event.type.compareTo("Online") == 0) {
        onlineEvents.add(event);
      } else if (event.type.compareTo("Offline") == 0) {
        offlineEvents.add(event);
      } else if (event.type.compareTo("Location") == 0) {
        locationEvents.add(event);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.titleBarBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Events",
              style: TextStyle(
                color: Constants.titleBarTextColor,
                fontSize: 18,
              )),
          centerTitle: true,
        ),
        body: Container(
          color: Constants.mainBackgroundColor,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 1,
                            left: SizeConfig.blockSizeHorizontal * 2),
                        child: Text(
                          "Online",
                          style: TextStyle(
                            //decoration: TextDecoration.underline,
                            fontSize: Constants.homePageHeadingsFontSize,
                          ),
                        )),
                    Divider(
                        indent: SizeConfig.blockSizeHorizontal * 2,
                        endIndent: SizeConfig.blockSizeHorizontal * 60,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical)
                  ],
                ),
              ),
              SliverPadding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 1,
                      left: SizeConfig.blockSizeHorizontal * 2,
                      right: SizeConfig.blockSizeHorizontal * 2),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                          height: SizeConfig.blockSizeVertical * 24,
                          width: SizeConfig.blockSizeHorizontal * 96,
                          child: GestureDetector(
                          onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SingleEventPageViewHandler()
                                        .getViewAccordingToEventType(
                                        onlineEvents[index])));
                      },
                      child:CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: onlineEvents[index].url)));
                    },
                    childCount: onlineEvents.length,
                  ))),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 1,
                            left: SizeConfig.blockSizeHorizontal * 2),
                        child: Text(
                          "Location",
                          style: TextStyle(
                            //decoration: TextDecoration.underline,
                            fontSize: Constants.homePageHeadingsFontSize,
                          ),
                        )),
                    Divider(
                        indent: SizeConfig.blockSizeHorizontal * 2,
                        endIndent: SizeConfig.blockSizeHorizontal * 60,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical)
                  ],
                ),
              ),
              SliverPadding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 1,
                      left: SizeConfig.blockSizeHorizontal * 2,
                      right: SizeConfig.blockSizeHorizontal * 2),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                          height: SizeConfig.blockSizeVertical * 24,
                          width: SizeConfig.blockSizeHorizontal * 96,
                          child: GestureDetector(
                          onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SingleEventPageViewHandler()
                                        .getViewAccordingToEventType(
                                        locationEvents[index])));
                      },
                      child:CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: locationEvents[index].url)));
                    },
                    childCount: locationEvents.length,
                  ))),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 1,
                            left: SizeConfig.blockSizeHorizontal * 2),
                        child: Text(
                          "Offline",
                          style: TextStyle(
                            //decoration: TextDecoration.underline,
                            fontSize: Constants.homePageHeadingsFontSize,
                          ),
                        )),
                    Divider(
                        indent: SizeConfig.blockSizeHorizontal * 2,
                        endIndent: SizeConfig.blockSizeHorizontal * 60,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical)
                  ],
                ),
              ),
              SliverPadding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 1,
                      left: SizeConfig.blockSizeHorizontal * 2,
                      right: SizeConfig.blockSizeHorizontal * 2,
                      bottom: SizeConfig.blockSizeHorizontal * 7),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                          height: SizeConfig.blockSizeVertical * 24,
                          width: SizeConfig.blockSizeHorizontal * 96,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SingleEventPageViewHandler()
                                                .getViewAccordingToEventType(
                                                offlineEvents[index])));
                              },
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: offlineEvents[index].url)));
                    },
                    childCount: offlineEvents.length,
                  ))),
            ],
          ),
        ));
  }
}
