import 'dart:developer';

import 'package:else_app_two/Models/deals_model.dart';
import 'package:else_app_two/basicElements/bottom_nav_bar.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:else_app_two/basicElements/horizontal_list.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'Models/events_model.dart';

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
      home: MyHomePage(title: 'Else'),
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
  DatabaseManager manager = new DatabaseManager();
  final List<String> headings = ['Events', 'Deals', 'Trending'];
  final List<EventModel> eventList = new List();
  final List<DealModel> dealList = new List();
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    manageEventList();
    manageDealsList();
  }

  //receiving messages from native code.
  String _messageFromNative = 'no messages from native yet';
  static const mainActivityFromPlatform =
      const MethodChannel('com.else.apis.from.native.mainActivity');

  _MyHomePageState() {
    mainActivityFromPlatform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "foundBeacons":
        setState(() {
          _messageFromNative = call.arguments;
        });
        return new Future.value("");
    }
  }
  void manageDealsList(){
    manager.getDealsDBRef().onChildAdded.listen(_newDealAdded);
  }
  void _newDealAdded(Event event){
    DealModel newDeal = new DealModel(event.snapshot);
    if(newDeal.status=='active'){
      setState(() {
        dealList.add(newDeal);
      });
    }
  }
  void manageEventList() {
    manager.getEventsDBRef().onChildAdded.listen(_newEventAdded);
    manager.getEventsDBRef().onChildChanged.listen(_updateEvent);
  }

  void _updateEvent(Event event) {
    EventModel newEvent = new EventModel(event.snapshot);
    if (eventList.contains(newEvent)) {
      if (newEvent.status == 'inactive')
        setState(() {
          eventList.remove(newEvent);
        });
    }
  }

  void _newEventAdded(Event event) {
    EventModel newEvent = new EventModel(event.snapshot);
    if (newEvent.status == 'active') {
      setState(() {
        eventList.add(newEvent);
      });
    } else if (newEvent.status == 'inactive') {
      if (eventList.contains(newEvent)) {
        setState(() {
          eventList.remove(newEvent);
        });
      }
    }
  }

  //invoking native methods from dart code.
  String _bridgeStatus = 'native bridge not verified yet.';
  static const mainActivityToPlatform =
      const MethodChannel('com.else.apis.to.native.mainActivity');

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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Text('Events'),
          HorizontalList(eventList),
          Text('Deals'),
          HorizontalList(dealList),
          Text('Trending'),
          HorizontalList(eventList),
        ],
      ),
      bottomNavigationBar: BottomNavBar(context),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
/*Wrap(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children: <Widget>[Text('Events'), HorizontalList(eventList), Text('Deals'),HorizontalList(eventList)],
      )*/
