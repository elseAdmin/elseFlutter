import 'package:else_app_two/requests/request_screen.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class RequestSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(SizeConfig.blockSizeVertical * 1.8),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal),
            color: Constants.titleBarBackgroundColor,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.record_voice_over,
                      size: 35, color: Constants.navBarButton),
                  Text(
                    'Request',
                    style:
                        TextStyle(fontSize: 18, color: Constants.navBarButton),
                  )
                ]),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => RequestsPage()));
          },
        ));
  }
}
