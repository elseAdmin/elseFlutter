import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/basicElements/BallProgressIndicator.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/events/singleEvent/onlineEvent/all_submission_view.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class SubmissionGridView extends StatefulWidget {
  final String eventUid;
  const SubmissionGridView(this.eventUid);
  @override
  State<StatefulWidget> createState() => SubmissionGridViewState();
}

class SubmissionGridViewState extends State<SubmissionGridView> {
  List<String> urls;
  @override
  void initState() {
    DatabaseManager()
        .getLimitedApprovedSubmissionsForOnlineEvent(widget.eventUid)
        .then((imageUrls) {
      setState(() {
        urls = imageUrls;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (urls == null) {
      return SliverList(
        delegate: SliverChildListDelegate([
          BallProgressIndicator()
        ]),
      );

    } else if (urls != null && urls.isNotEmpty) {
      return SliverPadding(
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 1,
              right: SizeConfig.blockSizeHorizontal * 1,
          bottom:SizeConfig.blockSizeVertical*3),
          sliver: SliverGrid(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index != urls.length) {
                  return Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 1,
                          right: SizeConfig.blockSizeHorizontal * 1,
                          bottom: SizeConfig.blockSizeVertical * 1),
                      color: Constants.mainBackgroundColor,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover, imageUrl: urls[index]));
                } else {
                  return Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 1,
                          right: SizeConfig.blockSizeHorizontal * 1,
                          bottom: SizeConfig.blockSizeVertical * 1),
                      color: Constants.mainBackgroundColor,
                      child: GestureDetector(
                onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (BuildContext context) =>
                AllSubmissionWidget(widget.eventUid)));
                },
                child:Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                            Icon(Icons.arrow_forward),
                            Text("View All")
                          ]))));
                }
              },
              childCount: urls.length + 1,
            ),
          ));
    } else {
      return SliverList(
        delegate: SliverChildListDelegate([
          Center(
            child: Text(
              "No submissions yet",
              style: TextStyle(fontSize: 12),
            ),
          )
        ]),
      );
    }
  }
}
