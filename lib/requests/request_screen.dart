
import 'package:else_app_two/profileTab/request_card.dart';
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
            SingleChildScrollView(
              child: Card(
                child: ListTile(
                  title: Text('Kya request kr skta hai', textAlign: TextAlign.center,),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(4),),
                      Text('Lift gyi Main phasa hai'),
                      Padding(padding: EdgeInsets.all(4),),
                      Text('Wheel chair chahiye'),
                      Padding(padding: EdgeInsets.all(4),),
                      Text('Emergency hai koi gira pada hai'),
                      Padding(padding: EdgeInsets.all(4),),
                      Text('Parking mein andera hai kuch kr na'),
                      Padding(padding: EdgeInsets.all(4),),
                      Text('Main locked hu toilet mein'),
                      Padding(padding: EdgeInsets.all(4),),
                      Text('Kuch galat lg rha hai'),
                      Padding(padding: EdgeInsets.all(4),),
                      Text('Mera bacha kho gya'),
                      Padding(padding: EdgeInsets.all(4),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}