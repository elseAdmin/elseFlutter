import 'package:else_app_two/basicElements/bottomNavigationBarItemsList.dart';
import 'package:else_app_two/beaconAds/AdScreen.dart';
import 'package:else_app_two/beaconAds/models/ad_beacon_model.dart';
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
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final logger = Logger();
  int bottomNavIndex = 0;
  BottomNavigatorViewHandler handler = new BottomNavigatorViewHandler();
  BeaconServiceImpl beaconService;
  String _appTitle = Constants.universe;

  @override
  void initState() {
    beaconService = BeaconServiceImpl(pushAdScreen);
    super.initState();
    const nativeMessageReceivingChannel =
        const MethodChannel('com.else.apis.from.native');
    nativeMessageReceivingChannel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "beaconFound":
        await _postBeaconFound(call.arguments);
        return new Future.value("");
    }
  }

  _postBeaconFound(arguments) async {
    await beaconService.handleBeacon(arguments[1], arguments[2], arguments[3]);

    if (Constants.universe.compareTo("unityOneRohini") != 0 &&
        arguments[0].compareTo("00000000-0000-0000-0000-000000000000") == 0) {
      Constants.universe = "unityOneRohini";
      Constants.universeDisplayName = "UnityOne Rohini";
      if (_appTitle.compareTo(arguments.toString()) == 0) {
        //no need to update as previous title has been called
      } else {
        setState(() {
          _appTitle = Constants.universe;
        });
      }
    }
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

  void pushAdScreen(AdBeacon adBeacon) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AdScreen(adBeacon, true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        actions: <Widget>[getIconForBleStatus()],
        backgroundColor: Constants.titleBarBackgroundColor,
        title: Text(
          _appTitle,
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
