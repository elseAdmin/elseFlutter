import 'package:else_app_two/basicElements/qr_scanner.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/firestore/user_parking_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class Parking extends StatefulWidget{
  @override
  ParkingState createState() => ParkingState();
}

class ParkingState  extends State<Parking> {
  ParkingModel parking;
  @override
  void initState() {
    // TODO: implement initState
   DatabaseManager().getActiveParking().then((model){
     setState(() {
       parking = model;
     });
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(parking == null) {
      return Container(
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
          child: Center(
            child: Loading(
                indicator: BallPulseIndicator(),
                size: 50.0,
                color: Colors.blue),
          ));
    }else if(parking.sensorName==null){
      return QrScanner();
    }else{
      return Text("your car is parked at "+parking.sensorName);
    }
  }

}