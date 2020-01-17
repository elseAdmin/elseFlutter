import 'package:else_app_two/parkingTab/parkingElements/elevator.dart';
import 'package:else_app_two/parkingTab/parkingElements/stairs.dart';
import 'package:flutter/material.dart';

class Lobby extends StatefulWidget{
  final int factor;
  Lobby(this.factor);

  @override
  _Lobby createState() => _Lobby();
}

class _Lobby extends State<Lobby>{
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      height: 75.0 * widget.factor,
      width: 80.0 * widget.factor,
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
              Stairs(widget.factor),
              Padding(
                padding: EdgeInsets.only(right: 40.0),
              ),
            ],
          ),
          Container(
            height: 28.0 * widget.factor,
            width: 80.0 * widget.factor,
            child: Center(
              child: Text('LOBBY'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Elevator(widget.factor),
              Elevator(widget.factor),
              Elevator(widget.factor),
            ],
          )
        ],
      ),
    );
  }

}