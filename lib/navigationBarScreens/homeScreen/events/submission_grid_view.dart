import 'package:else_app_two/firebaseUtil/database_manager.dart';
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
      return SliverGrid(
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        // I'm forcing item heights
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Card(child: Image(image: NetworkImage(urls[index])));
          },
          childCount: urls.length,
        ),
      );
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