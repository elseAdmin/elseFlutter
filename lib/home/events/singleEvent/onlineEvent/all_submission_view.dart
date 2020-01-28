import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/basicElements/BallProgressIndicator.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllSubmissionWidget extends StatefulWidget {
  final String eventUid;
  const AllSubmissionWidget(this.eventUid);
  @override
  State<StatefulWidget> createState() => AllSubmissionWidgetState();
}

class AllSubmissionWidgetState extends State<AllSubmissionWidget> {
  List<String> urls;
  @override
  void initState() {
    DatabaseManager()
        .getAllApprovedSubmissionsForOnlineEvent(widget.eventUid)
        .then((imageUrls) {
      setState(() {
        urls = imageUrls;
      });
    });
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (urls != null) {
      return Scaffold(
          body: Container(
              color: Constants.mainBackgroundColor,
              child: CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Constants.mainBackgroundColor,
                  expandedHeight: SizeConfig.blockSizeVertical * 10,
                  floating: false,
                  pinned: true,
                ),
                SliverPadding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 1,
                        right: SizeConfig.blockSizeHorizontal * 1),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      // I'm forcing item heights
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                              padding: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 1,
                                  right: SizeConfig.blockSizeHorizontal * 1,
                                  bottom: SizeConfig.blockSizeVertical * 1),
                              color: Constants.mainBackgroundColor,
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover, imageUrl: urls[index]));
                        },
                        childCount: urls.length,
                      ),
                    ))
              ])));
    } else {
      return Container(
          color: Constants.mainBackgroundColor,
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
          child: BallProgressIndicator());
    }
  }
}
