import 'dart:async';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/multiUniverse/UniverseAdapter.dart';
import 'package:else_app_two/service/firebase_notifications.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class Bootstrap extends StatefulWidget {
  @override
  createState() => BootstrapState();
}

class BootstrapState extends State<Bootstrap> {
  @override
  void initState() {
    super.initState();

    //initializing Class variables
    Constants constants = new Constants();
    FirebaseNotifications().setUpFirebase();

    DatabaseManager().initializeData(navigationPage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig().init(context);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => UniverseAdapter()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Else",
              style: TextStyle(fontSize: 42),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 3,
                  left: SizeConfig.blockSizeHorizontal * 10,
                  right: SizeConfig.blockSizeHorizontal * 10),
              child: LinearProgressIndicator(),
            )
          ],
        ),
      ),
    ));
  }
}
