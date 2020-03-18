import 'dart:async';

import 'package:else_app_two/basicElements/LoadingDialog.dart';
import 'package:else_app_two/beaconAds/AdScreen.dart';
import 'package:else_app_two/beaconAds/models/ad_beacon_model.dart';
import 'package:else_app_two/home/home_page.dart';
import 'package:else_app_two/multiUniverse/helper.dart';
import 'package:else_app_two/multiUniverse/offPremiseScreen.dart';
import 'package:else_app_two/service/beacon_service.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UniverseAdapter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UniverseAdapterState();
}

class UniverseAdapterState extends State<UniverseAdapter> {
  BeaconServiceImpl beaconService;
  bool offPremise = true;
  UniverseHelper helper;
  @override
  void initState() {
    super.initState();
    beaconService = BeaconServiceImpl(pushAdScreen);
    helper = UniverseHelper();

    const nativeMessageReceivingChannel =
        const MethodChannel('com.else.apis.from.native');
    nativeMessageReceivingChannel.setMethodCallHandler(_handleMethod);
    Timer.periodic(Duration(seconds: 5), (timer) {
      Constants.universe = "else";
    });

    Timer.periodic(Duration(seconds: 4), (timer) {
      //method of average can be used to cancel the noise in readings
      if (Constants.universe.compareTo("else") == 0) {
        print("no universe detected. switching to off premise screen");
        setState(() {
          offPremise = true;
        });
      }
    });
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "beaconFound":
        await _postBeaconFound(call.arguments);
        return new Future.value();
    }
  }

  _postBeaconFound(arguments) async {
    if (helper.isUniverseKnown(arguments[0])) {
      if (helper.hasUniverseChanged(arguments[0]))
        print("beacon from a known universe detected.switching to home page");
      setState(() {
        offPremise = false;
      });
    }
    await beaconService.handleBeacon(arguments[1], arguments[2], arguments[3]);
  }

  @override
  Widget build(BuildContext context) {
    if (offPremise) {
      return OffPremiseScreen();
    } else {
      return MyHomePage();
    }
  }

  void pushAdScreen(AdBeacon adBeacon) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AdScreen(adBeacon, true));
  }
}
