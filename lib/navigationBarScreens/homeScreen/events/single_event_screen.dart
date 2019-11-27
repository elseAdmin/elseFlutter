import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/SubmissionSection.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/submission_grid_view.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class SingleEventScreen extends StatefulWidget {
  final EventModel event;
  final List<String> submissionUrls;
  const SingleEventScreen(this.event, this.submissionUrls);

  @override
  SingleEventPageState createState() => SingleEventPageState();
}

class SingleEventPageState extends State<SingleEventScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
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
                  background:  CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        CircularProgressIndicator(),
                    imageUrl: widget.event.url,
                  )),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 2),
                      child: Text(widget.event.description,
                          style: TextStyle(
                              fontSize: 16,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w300))),
                  Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 2),
                      child: Text(
                        "Submissions",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Constants.textColor,
                            fontSize: 18,
                            decoration: TextDecoration.underline),
                      )),
                  SubmissionSection(widget.event),
                  Divider(
                      indent: SizeConfig.blockSizeHorizontal * 7,
                      endIndent: SizeConfig.blockSizeHorizontal * 7,
                      color: Colors.black87,
                      height: SizeConfig.blockSizeVertical * 5),
                ],
              ),
            ),
           SubmissionGridView(widget.event.uid),
          ],
        ),
      ),
    );
  }
}
