
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.titleBarBackgroundColor,
        iconTheme: IconThemeData(
          color: Constants.textColor, //change your color here
        ),
        title: Text("Requests",
          style: TextStyle(
            color: Constants.titleBarTextColor,
            fontSize: 18,
          ),
        ),
      ),
      body: Card(
        borderOnForeground: true,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white70,
                width: 1.0,
              ),
            ),
            child: Column(
              children: <Widget>[
                Text('New Request',
                  style: TextStyle(
                    color: Constants.textColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Name'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Phone'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
                TextField(
                  maxLines: 8,
                  decoration: const InputDecoration(
                      labelText: 'Message'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
                RaisedButton(
                  color: Constants.titleBarBackgroundColor,
                  onPressed: () => {

                  },
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}