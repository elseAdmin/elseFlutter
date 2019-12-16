import 'package:else_app_two/basicElements/AdScreen.dart';
import 'package:else_app_two/basicElements/bottomNavigationBarItemsList.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/service/beacon_service.dart';
import 'package:else_app_two/service/bottom_navigator_view_handler.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'auth/auth.dart';
import 'auth/auth_provider.dart';

void main() {
  runApp(MaterialApp(
    title: 'Else',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
        auth: Auth(),
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home: MyHomePage(title: 'Else')));
  }
}

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
    //_getBridgeStatus();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "beaconFound":
        await _postBeaconFound(call.arguments);
        return new Future.value("");
    }
  }

  _postBeaconFound(arguments) async {
    await beaconService.handleBeacon(arguments[1], arguments[2]);

    if (Constants.universe.compareTo("Else") == 0 &&
        arguments[0].compareTo("00000000-0000-0000-0000-000000000000") == 0) {
      Constants.universe = "unityOneRohini";
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

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    return null;
  }

  void pushAdScreen(String imageUrl) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AdScreen(imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.titleBarBackgroundColor,
        title: Text(
          _appTitle,
          style: TextStyle(
            color: Constants.titleBarTextColor,
            fontSize: 18,
          ),
        ),
      ),
      body: RefreshIndicator(
        child: handler.getViewForNavigationBarIndex(bottomNavIndex),
        onRefresh: _handleRefresh,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavIndex,
        type: BottomNavigationBarType.fixed,
        items: BottomNavigationBarItemsList().getItems(),
        onTap: (index) {
          _handleBottomNavigationTab(index);
        },
      ),
    );
  }

  _handleBottomNavigationTab(int index) {
    setState(() {
      bottomNavIndex = index;
    });
  }
}
