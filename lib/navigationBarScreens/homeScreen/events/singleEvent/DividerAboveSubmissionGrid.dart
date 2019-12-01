import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DividerAboveSubmissionGrid extends StatefulWidget{
  final EventModel event;
  const DividerAboveSubmissionGrid(this.event);
  @override
  DividerAboveSubmissionGridState createState()=>DividerAboveSubmissionGridState();
}
class DividerAboveSubmissionGridState extends State<DividerAboveSubmissionGrid>{
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if(widget.event.endDate.isBefore(DateTime.now())) {
      return Container(child:
      Column(children:<Widget>[Divider(
          indent: SizeConfig.blockSizeHorizontal * 7,
          endIndent: SizeConfig.blockSizeHorizontal * 7,
          color: Colors.black87,
          height: SizeConfig.blockSizeVertical * 5),
        Container(padding:EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*2),child:Text("Winner",style: TextStyle(decoration: TextDecoration.underline,fontSize:22 ),))
      ]
      ));
    }else{
      return Container(child:Divider(
          indent: SizeConfig.blockSizeHorizontal * 7,
          endIndent: SizeConfig.blockSizeHorizontal * 7,
          color: Colors.black87,
          height: SizeConfig.blockSizeVertical * 5));
    }
  }

}