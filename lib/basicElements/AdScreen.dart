import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class AdScreen extends StatelessWidget{
  final String imageUrl ;
  const AdScreen(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Container(
        height: SizeConfig.blockSizeVertical*43,
        width: SizeConfig.blockSizeHorizontal*70,
        child: Column(
          children: <Widget>[
            Container(
                color: Colors.transparent,
                height: SizeConfig.blockSizeVertical*30,
                child:Image(fit:BoxFit.cover,image: NetworkImage(this.imageUrl))),
          ],
        ),
      ),
    );
  }

}