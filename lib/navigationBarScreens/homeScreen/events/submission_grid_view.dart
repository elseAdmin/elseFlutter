import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class SubmissionGridView extends StatefulWidget{
  final String eventUid;
  const SubmissionGridView(this.eventUid);
  @override
  State<StatefulWidget> createState() => SubmissionGridViewState();
}

class SubmissionGridViewState extends State<SubmissionGridView>{
  List<String> urls;
  @override
  void initState(){
    DatabaseManager().getApprovedSubmissionsForEvent(widget.eventUid).then((imageUrls){
      setState(() {
        urls=imageUrls;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (urls == null) {
      return SliverList(
        delegate: SliverChildListDelegate([
          Center(
            child: Loading(indicator: BallPulseIndicator(),
                size: 60.0,
                color: Colors.blue),
          )
        ]),
      );
    } else if(urls!=null && urls.isNotEmpty){
      return SliverPadding(
          padding:EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*2,bottom: SizeConfig.blockSizeVertical*5),
          sliver:SliverGrid(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        // I'm forcing item heights
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Container(

                color:Colors.black,child: CachedNetworkImage(fit:BoxFit.cover,imageUrl:urls[index]));
          },
          childCount: urls.length,
        ),
      ));
    } else {
      return SliverList(
        delegate: SliverChildListDelegate([
          Center(
            child: Text("No submissions yet",style: TextStyle(fontSize: 12),),
          )
        ]),
      );
    }
  }

}