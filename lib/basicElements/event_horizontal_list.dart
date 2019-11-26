import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/event_list_page.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/single_event_screen.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EventSection extends StatefulWidget {
  @override
  EventSectionState createState() => new EventSectionState();
}

class EventSectionState extends State<EventSection> {
  List<EventModel> events = new List();
  final DatabaseManager manager = DatabaseManager();

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
    manager.getApprovedSubmissionsForEvent("UORCHR01");
    SizeConfig().init(context);
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*1,left: SizeConfig.blockSizeHorizontal*2),
            child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => EventListPage(events)));
          },
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Events",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: Constants.homePageHeadingsFontSize,
                ),
              )),
        )),
        Container(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*1,right: SizeConfig.blockSizeHorizontal*1),
            height: MediaQuery.of(context).size.height * 0.30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Card(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SingleEventScreen(events[index],List())));
                            },
                            child: Stack(
                              fit: StackFit.passthrough,
                              children: <Widget>[
                                Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(events[index].blurUrl)),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(events[index].name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 19))),
                              ],
                            )),
                      ));
                }))
      ],
    );
  }
}
