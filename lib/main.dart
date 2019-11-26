import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/service/bottom_navigator_view_handler.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
//      home: MyHomePage(title: 'Else'),
      home: OauthManager(false),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final logger = Logger();

  int bottomNavIndex=0;
  BottomNavigatorViewHandler handler= new BottomNavigatorViewHandler();

  @override
  void initState() {
    super.initState();

    const nativeMessageReceivingChannel =
    const MethodChannel('com.else.apis.from.native');
    nativeMessageReceivingChannel.setMethodCallHandler(_handleMethod);
    _getBridgeStatus();
  }

  //receiving messages from native code.
  String _appTitle = 'Else';


  _MyHomePageState() {

  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "universeIdentified":
        _updateTitleIfNeeded(call.arguments);
        return new Future.value("");
    }
  }


  //invoking native methods from dart code.
  String _bridgeStatus = 'native bridge not verified yet.';
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
  }
  _handleBottomNavigationTab(int index){
    setState(() {
      bottomNavIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appTitle),
      ),
      body: handler.getViewForNavigationBarIndex(bottomNavIndex),
      bottomNavigationBar:BottomNavigationBar(
        currentIndex: bottomNavIndex,
        type: BottomNavigationBarType.fixed ,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Home', style: TextStyle(
                color: Colors.blue,
              ))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.navigation,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Navigate', style: TextStyle(
                color: Colors.blue,
              ))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_parking,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Parking', style: TextStyle(
                color: Colors.blue,
              ))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Notify', style: TextStyle(
                color: Colors.blue,
              ))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.verified_user,color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text('Profile', style: TextStyle(
                color: Colors.blue,
              ))
          )
        ],
        onTap: (index){
          _handleBottomNavigationTab(index);
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _updateTitleIfNeeded(arguments) {
    logger.i("flutter method called by native");
    if(_appTitle.compareTo(arguments.toString())==0){
      //no need to update as previous title has been called
    }else{
      setState(() {
        _appTitle = arguments;
      });
    }
  }
}
