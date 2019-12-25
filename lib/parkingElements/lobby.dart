import 'package:else_app_two/parkingElements/elevator.dart';
import 'package:else_app_two/parkingElements/stairs.dart';
import 'package:flutter/material.dart';

class Lobby extends StatefulWidget{
  @override
  _Lobby createState() => _Lobby();
}

class _Lobby extends State<Lobby>{
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      height: 75.0,
      width: 80.0,
      decoration: BoxDecoration(
        color: Colors.deepOrange[50],
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Stairs(),
              Padding(
                padding: EdgeInsets.only(right: 40.0),
              ),
            ],
          ),
          Container(
            height: 28,
            width: 80,
            child: Center(
              child: Text('LOBBY'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Elevator(),
              Elevator(),
              Elevator(),
            ],
          )
        ],
      ),
    );
  }

}