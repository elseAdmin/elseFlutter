import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/home/events/singleEvent/onlineEvent/DividerAboveSubmissionGrid.dart';
import 'package:else_app_two/home/events/singleEvent/EventStaticData.dart';
import 'package:else_app_two/home/events/singleEvent/onlineEvent/SubmissionGridViewHandler.dart';
import 'package:else_app_two/home/events/singleEvent/onlineEvent/SubmissionSection.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class OnlineEventScreen extends StatefulWidget {
  final EventModel event;
  const OnlineEventScreen(this.event);

  @override
  OnlineEventScreenState createState() => OnlineEventScreenState();
}

class OnlineEventScreenState extends State<OnlineEventScreen> {


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
                  Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 2,
                          top: SizeConfig.blockSizeVertical),
                      child: Text(
                        "Submissions",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Constants.textColor,
                            fontSize: 18,
                            decoration: TextDecoration.underline),
                      )),
                  SubmissionSection(widget.event),
                  DividerAboveSubmissionGrid(widget.event),
                ],
              ),
            ),
            SubmissionGridViewHandler(widget.event)
                .renderSuitableSubmissionGridView()
          ],
        ),
      ),
    );
  }
}
