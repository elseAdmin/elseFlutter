import 'package:else_app_two/requests/request_screen.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class RequestSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1,
            left: SizeConfig.blockSizeHorizontal * 2),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => RequestsPage()));
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Requests",
                    style: TextStyle(
                      fontSize: Constants.homePageHeadingsFontSize,
                    ),
                  ),
                  Divider(
                      endIndent: SizeConfig.blockSizeHorizontal * 60,
                      color: Colors.black87,
                      height: SizeConfig.blockSizeVertical)
                ])));
  }
}
