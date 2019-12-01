import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventStaticData extends StatelessWidget {
  final String rules, description;
  EventStaticData(this.description, this.rules);
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 2,
                  top: SizeConfig.blockSizeVertical * 2),
              child: Text("About",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Constants.textColor,
                      fontSize: 18,
                      decoration: TextDecoration.underline))),
          Container(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeVertical * 2,
                  top: SizeConfig.blockSizeVertical * 2,
                  right: SizeConfig.blockSizeVertical * 2),
              child: Text(description,
                  style: TextStyle(
                      fontSize: 15,
                      color: Constants.textColor,
                      fontWeight: FontWeight.w300))),
          Container(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeVertical * 2,
                  top: SizeConfig.blockSizeVertical),
              child: GestureDetector(
                  onTap: () {},
                  child: Text("NoteWorthy",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w300))))
        ]);
  }
}
