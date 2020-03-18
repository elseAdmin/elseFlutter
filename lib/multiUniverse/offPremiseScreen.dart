import 'package:flutter/material.dart';

class OffPremiseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OffPremiseScreenState();
}

class OffPremiseScreenState extends State<OffPremiseScreen> {
  @override
  Widget build(BuildContext context) {
    print("building off page");
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "OffPremise",
                  style: TextStyle(fontSize: 42),
                ),
              ],
            ),
          ),
        )));
  }
}
