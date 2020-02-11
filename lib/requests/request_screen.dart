import 'package:else_app_two/requests/request_card.dart';
import 'package:else_app_two/requests/request_example.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  @override
  RequestPageState createState() => RequestPageState();
}

class RequestPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Constants.navBarButton, //change your color here
        ),
        title: Text(
          "Request",
          style: TextStyle(
            color: Constants.navBarButton,
            fontSize: 18,
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Constants.navBarButton,
          child: Icon(Icons.send),
          onPressed: () {

          },
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
