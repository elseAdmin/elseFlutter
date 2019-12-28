import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:flutter/cupertino.dart';

class ActivityMainScreen extends StatefulWidget{
  List activities;
  ActivityMainScreen(this.activities);
  @override
  createState() => ActivityMainScreenState();
}

class ActivityMainScreenState extends State<ActivityMainScreen>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Text(widget.activities.length.toString());
  }
}