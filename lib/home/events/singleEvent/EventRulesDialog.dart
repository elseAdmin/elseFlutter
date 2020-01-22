import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RulesDialog extends StatelessWidget {
  final List rules;
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
            width: double.maxFinite,
            child: ListView.builder(
          itemCount: rules.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(children: <Widget>[
              Container(padding:EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*2,right:SizeConfig.blockSizeHorizontal*2),child:Icon(Icons.check_circle)),
              Text(rules[index])],);
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        )),
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
