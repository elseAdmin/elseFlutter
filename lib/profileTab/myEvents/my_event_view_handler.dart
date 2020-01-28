import 'package:else_app_two/models/base_model.dart';
import 'package:else_app_two/profileTab/myEvents/my_event_card.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class MyEventViewHandler {
  Widget getAppropriateView(List<Map<String, BaseModel>> details) {
    if (details.isEmpty) {
      return Center(
        child: Text("You have not participated in any event yet"),
      );
    } else {
      return Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2,
                            left: SizeConfig.blockSizeHorizontal * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Total events participated : " +
                                  details.length.toString(),
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        )),
                    Divider(
                        indent: SizeConfig.blockSizeHorizontal * 7,
                        endIndent: SizeConfig.blockSizeHorizontal * 7,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical * 5)
                  ],
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return MyEventCard(details[index]);
              }, childCount: details.length)),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Divider(
                        indent: SizeConfig.blockSizeHorizontal * 7,
                        endIndent: SizeConfig.blockSizeHorizontal * 7,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical * 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Else",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ));
    }
  }
}
