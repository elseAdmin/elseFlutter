import 'package:else_app_two/basicElements/qr_scanner.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/parkingTab/models/user_parking_model.dart';
import 'package:else_app_two/parkingTab/parking_ui_screen.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class Parking extends StatefulWidget {
  @override
  ParkingState createState() => ParkingState();
}

class ParkingState extends State<Parking> {
  ParkingModel parking;
  bool isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    if(StartupData.user!=null) {
      isLoggedIn=true;
      DatabaseManager().getActiveParking().then((model) {
        setState(() {
          parking = model;
        });
      });
    }
    super.initState();
  }
  redirectLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OauthManager(onSignedIn: _signedIn),
      ),
    );
  }

  void _signedIn() {
    DatabaseManager().getActiveParking().then((model) {
      setState(() {
        isLoggedIn=true;
        parking = model;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      if (parking == null) {
        return Container(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
            child: Center(
              child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 50.0,
                  color: Colors.blue),
            ));
      } else if (parking.sensorName == null) {
        return QrScanner();
      } else {
        return ParkingUIScreen(parking);
      }
    } else {
      return Center(
        child: GestureDetector(
          onTap: redirectLogin,
          child: Text("Login to use Else's automated parking"),
        ),
      );
    }
  }
}
