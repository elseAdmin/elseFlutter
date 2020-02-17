import 'package:else_app_two/basicElements/BallProgressIndicator.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build

    return SimpleDialog(
        children: <Widget>[
          Container(
              height: SizeConfig.blockSizeVertical * 20,
              child: BallProgressIndicator())
        ]);
  }
}
