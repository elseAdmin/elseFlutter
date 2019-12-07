
import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/requests/request_card.dart';
import 'package:else_app_two/requests/request_example.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget{
  @override
  RequestPageState createState() => RequestPageState();

}
class RequestPageState extends State<RequestsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.titleBarBackgroundColor,
        iconTheme: IconThemeData(
          color: Constants.textColor, //change your color here
        ),
        title: Text("Make a request",
          style: TextStyle(
            color: Constants.titleBarTextColor,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RequestCard(),
            RequestExample(),
          ],
        ),
      ),
    );
  }
}