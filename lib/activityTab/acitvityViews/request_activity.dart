import 'package:else_app_two/requests/models/user_request_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class RequestActivity extends StatelessWidget {
  final UserRequestModal request;
  RequestActivity(this.request);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*0.5,left: SizeConfig.blockSizeHorizontal),
        child: GestureDetector(
          onTap: () => {

          },
            child: Text("You have made a request at " + request.universe)));
  }
}
