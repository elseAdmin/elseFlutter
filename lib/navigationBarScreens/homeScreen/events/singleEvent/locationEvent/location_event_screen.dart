import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/singleEvent/EventRulesDialog.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/singleEvent/EventStaticData.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/singleEvent/locationEvent/submission_view.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class LocationEventScreen extends StatefulWidget {
  final EventModel event;
  const LocationEventScreen(this.event);

  @override
  LocationEventScreenState createState() => LocationEventScreenState();
}

class LocationEventScreenState extends State<LocationEventScreen> {
  viewRules() {
    showDialog(
        context: context,
        builder: (BuildContext context) => RulesDialog(widget.event.rules));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
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
                  background: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: widget.event.url,
                  )),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  EventStaticData(widget.event.description, widget.event.rules),
                  SubmissionView(widget.event),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
