import 'dart:collection';

import 'package:else_app_two/models/sensor_model.dart';
import 'package:else_app_two/parkingTab/parkingElements/lobby.dart';
import 'package:else_app_two/parkingTab/parkingElements/parking_slot.dart';
import 'package:flutter/material.dart';

class SectionBParking extends StatefulWidget{
  final HashMap<String, SensorModel> _sensorModelMap;
  final HashMap<String, bool> _userMap;
  final int factor;
  SectionBParking(this._sensorModelMap, this._userMap, this.factor);

  @override
  _SectionBParking createState() => _SectionBParking();
}

class _SectionBParking extends State<SectionBParking>{
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ParkingSlot(1, 'A3', widget.factor, 3, false),
              paddingRightData(),
              ParkingSlot(1, 'B3', widget.factor, 1, false),
              ParkingSlot(1, 'D3', widget.factor, 3, false),
              paddingRightData(),
              ParkingSlot(1, 'E3', widget.factor, 1, false),
            ],
          ),
          Row(
//            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  ParkingSlot(widget._sensorModelMap['sensor5'].value, widget._sensorModelMap['sensor5'].slot, widget.factor, 3, widget._userMap['sensor5']),
                  ParkingSlot(widget._sensorModelMap['sensor6'].value, widget._sensorModelMap['sensor6'].slot, widget.factor, 3, widget._userMap['sensor6']),
                  ParkingSlot(widget._sensorModelMap['sensor7'].value, widget._sensorModelMap['sensor7'].slot, widget.factor, 3, widget._userMap['sensor7']),
                ],
              ),
              Container(
                width: 40.0 * widget.factor,
                height: 75.0 * widget.factor,
                child: IconButton(icon: Icon(Icons.arrow_upward),),
              ),
              Lobby(widget.factor),
              Container(
                width: 40.0 * widget.factor,
                height: 75.0 * widget.factor,
                child: IconButton(icon: Icon(Icons.arrow_downward),),
              ),
              Column(
                children: <Widget>[
                  ParkingSlot(1, 'E4', widget.factor, 1, false),
                  ParkingSlot(1, 'E5', widget.factor, 1, false),
                  ParkingSlot(1, 'E6', widget.factor, 1, false),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              ParkingSlot(widget._sensorModelMap['sensor8'].value, widget._sensorModelMap['sensor8'].slot, widget.factor, 3, widget._userMap['sensor8']),
              paddingRightData(),
              ParkingSlot(0, 'B7', widget.factor, 1, false),
              ParkingSlot(0, 'D7', widget.factor, 3, false),
              paddingRightData(),
              ParkingSlot(0, 'E7', widget.factor, 1, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget paddingBottomData(){
    return Container(
      height: 40.0 * widget.factor,
    );
  }

  Widget paddingRightData(){
    return Container(
      width: 40.0 * widget.factor,
    );
  }

}