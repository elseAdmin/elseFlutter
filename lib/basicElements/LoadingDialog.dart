import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build

    return SimpleDialog(
        title: Text(
          "Loading",
          textAlign: TextAlign.center,
        ),
        elevation: 20,
        children: <Widget>[
          Container(
              height: SizeConfig.blockSizeVertical * 30,
              width: SizeConfig.blockSizeHorizontal * 60,
              child: CircularProgressIndicator())
        ]);
  }
}
