import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/singleEvent/EventRulesDialog.dart';
import 'package:else_app_two/home/events/singleEvent/EventStaticData.dart';
import 'package:else_app_two/home/events/singleEvent/locationEvent/submission_view.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class LocationEventScreen extends StatefulWidget {
  EventModel event;
  LocationEventScreen(this.event);

  @override
  LocationEventScreenState createState() => LocationEventScreenState();
}

class LocationEventScreenState extends State<LocationEventScreen> {
  viewRules() {
    showDialog(
        context: context,
        builder: (BuildContext context) => RulesDialog(widget.event.rules));
  }

  Future<Null> _handleRefresh() async {
    EventModel refreshedEvent = await DatabaseManager()
        .getEventModelFromEventUrl(
            DatabaseManager().getEventsDBRef().path + "/" + widget.event.uid);
    setState(() {
      widget.event = refreshedEvent;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Scaffold(
          body: Container(
            color: Constants.mainBackgroundColor,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: SizeConfig.blockSizeVertical * 30,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(widget.event.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          )),
                      background: Opacity(
                          opacity: 0.6,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: widget.event.url,
                          ))),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      EventStaticData(
                          widget.event.description, widget.event.rules),
                      SubmissionView(widget.event),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
