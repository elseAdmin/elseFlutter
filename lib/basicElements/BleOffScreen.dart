import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class BleOffDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build

    return SimpleDialog(
        elevation: 20,
        children: <Widget>[
          Container(
              height: SizeConfig.blockSizeVertical * 30,
              width: SizeConfig.blockSizeHorizontal * 60,
              child: Text("Bluetooth is off"))
        ]);
  }
}
