import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'EventRulesDialog.dart';

class EventStaticData extends StatefulWidget {
  final String description;
  final List rules;
  EventStaticData(this.description, this.rules);
  @override
  State<StatefulWidget> createState() => EventStaticDataState();
}

class EventStaticDataState extends State<EventStaticData> {
  _viewRules() {
    showDialog(
        context: context,
        builder: (BuildContext context) => RulesDialog(widget.rules));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeVertical * 2,
                  top: SizeConfig.blockSizeVertical * 2,
                  right: SizeConfig.blockSizeVertical * 2),
              child: Text(widget.description,
                  style: TextStyle(
                      fontSize: 15,
                      color: Constants.textColor,
                      fontWeight: FontWeight.w300))),
          Container(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeVertical * 2,
                  top: SizeConfig.blockSizeVertical),
              child: GestureDetector(
                  onTap: () {
                    _viewRules();
                  },
                  child: Text("NoteWorthy",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w300))))
        ]);
  }
}
