import 'dart:collection';

import 'package:else_app_two/models/sensor_model.dart';
import 'package:else_app_two/parkingTab/parkingElements/parking_slot.dart';
import 'package:flutter/material.dart';

class SectionAParking extends StatefulWidget{

  final HashMap<String, SensorModel> _sensorModelMap;
  final HashMap<String, bool> _userMap;
  final int factor;

  SectionAParking(this._sensorModelMap, this._userMap, this.factor);

  @override
  _SectionAParking createState() => _SectionAParking();
}

class _SectionAParking extends State<SectionAParking>{
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ParkingSlot(1, 'C1', widget.factor, 0, false),
              ParkingSlot(0, 'C2', widget.factor, 0, false),
              ParkingSlot(1, 'C3', widget.factor, 0, false),
              ParkingSlot(1, 'C4', widget.factor, 0, false),
              ParkingSlot(0, 'C5', widget.factor, 0, false),
              ParkingSlot(1, 'C6', widget.factor, 0, false),
              ParkingSlot(1, 'C7', widget.factor, 0, false),
              ParkingSlot(0, 'C8', widget.factor, 0, false),
              ParkingSlot(widget._sensorModelMap['sensor9'].value, widget._sensorModelMap['sensor9'].slot, widget.factor, 0, widget._userMap['sensor9']),
              ParkingSlot(1, 'C10', widget.factor, 0, false),
            ],
          ),
          paddingBottomData(),
          Row(
            children: <Widget>[
              ParkingSlot(0, 'A1', widget.factor, 3, false),
              paddingRightData(),
              ParkingSlot(widget._sensorModelMap['sensor3'].value, widget._sensorModelMap['sensor3'].slot, widget.factor, 1, widget._userMap['sensor3']),
              ParkingSlot(widget._sensorModelMap['sensor1'].value, widget._sensorModelMap['sensor1'].slot, widget.factor, 3, widget._userMap['sensor1']),
              paddingRightData(),
              ParkingSlot(0, 'E1', widget.factor, 1, false),
            ],
          ),
          Row(
            children: <Widget>[
              ParkingSlot(1, 'A2', widget.factor, 3, false),
              paddingRightData(),
              ParkingSlot(widget._sensorModelMap['sensor4'].value, widget._sensorModelMap['sensor4'].slot, widget.factor, 1, widget._userMap['sensor4']),
              ParkingSlot(widget._sensorModelMap['sensor2'].value, widget._sensorModelMap['sensor2'].slot, widget.factor, 3, widget._userMap['sensor2']),
              paddingRightData(),
              ParkingSlot(0, 'E2', widget.factor, 1, false),
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