import 'package:else_app_two/parkingTab/models/user_parking_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class ParkingActivity extends StatelessWidget {
  final ParkingModel parking;
  ParkingActivity(this.parking);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1,
            left: SizeConfig.blockSizeHorizontal),
        child: GestureDetector(
            onTap: () => {},
            child: Text("Your parking was captured at " +
                parking.timestamp.toString())));
  }
}
