import 'dart:async';

import 'package:else_app_two/basicElements/LoadingDialog.dart';
import 'package:else_app_two/basicElements/bottomNavigationBarItemsList.dart';
import 'package:else_app_two/beaconAds/AdScreen.dart';
import 'package:else_app_two/beaconAds/models/ad_beacon_model.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/multiUniverse/helper.dart';
import 'package:else_app_two/multiUniverse/offPremiseScreen.dart';
import 'package:else_app_two/service/beacon_service.dart';
import 'package:else_app_two/service/bottom_navigator_view_handler.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:flutter_blue/flutter_blue.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final logger = Logger();
  int bottomNavIndex = 0;
  bool dataLoading = true;
  BottomNavigatorViewHandler handler = new BottomNavigatorViewHandler();

  @override
  void initState() {
    print("init home page");
    super.initState();
    DatabaseManager().initialiseUniverseData(dismissLoader);
  }

  dismissLoader() {
    //dataLoading = false;
    //Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //invoking native methods from dart code.
  /* String _bridgeStatus = 'native bridge not verified yet.';
  static const mainActivityToPlatform =
      const MethodChannel('com.else.apis.to.native');

  Future<void> _getBridgeStatus() async {
    String bridgeStatus;
    try {
      final String result =
          await mainActivityToPlatform.invokeMethod('nativeBridging');
      bridgeStatus = 'Bridge status : ' + result;
    } on PlatformException catch (e) {
      bridgeStatus = "Failed to bridge to native '${e.message}'.";
    }

    setState(() {
      _bridgeStatus = bridgeStatus;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    print("building home page");
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        actions: <Widget>[getIconForBleStatus()],
        backgroundColor: Constants.titleBarBackgroundColor,
        title: Text(
          Constants.universe,
          style: TextStyle(
            color: Constants.navBarButton,
            fontSize: 18,
          ),
        ),
      ),
      body: handler.getViewForNavigationBarIndex(bottomNavIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Constants.titleBarBackgroundColor,
        currentIndex: bottomNavIndex,
        type: BottomNavigationBarType.fixed,
        items: BottomNavigationBarItemsList().getItems(),
        onTap: (index) {
          _handleBottomNavigationTab(index);
        },
      ),
    );
  }

  getIconForBleStatus() {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state != BluetoothState.on) {
            StartupData.isBluetoothOn = false;
            return Container(
                padding:
                    EdgeInsets.only(right: SizeConfig.blockSizeVertical * 2),
                child: Icon(
                  Icons.bluetooth_disabled,
                  color: Colors.red,
                ));
          }
          StartupData.isBluetoothOn = true;
          return Container();
        });
  }

  _handleBottomNavigationTab(int index) {
    setState(() {
      bottomNavIndex = index;
    });
  }
}
