import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RulesDialog extends StatelessWidget {
  final String rules;
  RulesDialog(this.rules);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SimpleDialog(
      title: Text(
        "Rules",
        textAlign: TextAlign.center,
      ),
      elevation: 20,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 3,
                right: SizeConfig.blockSizeHorizontal * 3,
                top: SizeConfig.blockSizeVertical),
            child: Text(rules)),
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                child: Text("Ok",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18))))
      ],
    );
  }
}
