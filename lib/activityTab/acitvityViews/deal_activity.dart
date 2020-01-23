import 'package:else_app_two/beaconAds/AdScreen.dart';
import 'package:else_app_two/beaconAds/models/ad_beacon_model.dart';
import 'package:else_app_two/beaconAds/models/user_deal_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class DealActivity extends StatelessWidget{
  final UserDealModel deal;
  DealActivity(this.deal);
  buildAdBeaconModelFromUserDealModel(){
    AdBeacon ad = AdBeacon(null);
    ad.shopUid = this.deal.shopUid;
    ad.imageUrl = this.deal.imageUrl;
    return ad;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*0.5,left: SizeConfig.blockSizeHorizontal),
        child: GestureDetector(
            onTap: () => {
            showDialog(
            context: context,
            builder: (BuildContext context) => AdScreen(buildAdBeaconModelFromUserDealModel(),false))
            },
            child: Text("Grabbed a deal at " + deal.universe)));
  }

}