import 'package:else_app_two/beaconAds/models/ad_beacon_model.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class AdScreen extends StatelessWidget {
  final AdBeacon adBeaconModel;
  const AdScreen(this.adBeaconModel, this.forAd);
  final bool forAd;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build

    return SimpleDialog(
        title: Text(
          "Flash Deal!!",
          textAlign: TextAlign.center,
        ),
        elevation: 20,
        children: <Widget>[
          Container(
            //height: SizeConfig.blockSizeVertical * 43,
            width: SizeConfig.blockSizeHorizontal * 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    //height: SizeConfig.blockSizeVertical * 30,
                    child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(this.adBeaconModel.imageUrl))),
                Visibility(
                    visible: forAd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical,
                                left: SizeConfig.blockSizeHorizontal * 6),
                            child: GestureDetector(
                                onTap: () => markDealGrabbed(context),
                                child: Text("Grab",
                                    style: TextStyle(fontSize: 22)))),
                        Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical,
                                right: SizeConfig.blockSizeHorizontal * 6),
                            child: GestureDetector(
                                onTap: () => onPass(context),
                                child: Text("Pass",
                                    style: TextStyle(fontSize: 22))))
                      ],
                    )),
                Visibility(
                    visible: !forAd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical,
                                left: SizeConfig.blockSizeHorizontal * 6),
                            child: GestureDetector(
                                onTap: () => markDealGrabbed(context),
                                child: Text("Grabbed at :",
                                    style: TextStyle(fontSize: 22)))),
                        Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical,
                                right: SizeConfig.blockSizeHorizontal * 6),
                            child: Text(adBeaconModel.shopUid,
                                style: TextStyle(fontSize: 22)))
                      ],
                    )),
              ],
            ),
          )
        ]);
  }

  markDealGrabbed(BuildContext context) {
    DatabaseManager().markDealSeenForUser(this.adBeaconModel, "grab");
    Navigator.pop(context);
  }

  onPass(BuildContext context) {
    DatabaseManager().markDealSeenForUser(this.adBeaconModel, "pass");
    Navigator.pop(context);
  }
}
