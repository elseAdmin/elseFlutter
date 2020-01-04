import 'package:else_app_two/beaconAds/models/user_deal_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class DealActivity extends StatelessWidget{
  final UserDealModel deal;
  DealActivity(this.deal);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*0.5,left: SizeConfig.blockSizeHorizontal),
        child: GestureDetector(
            onTap: () => {

            },
            child: Text("Grabbed a deal at " + deal.universe)));
  }

}