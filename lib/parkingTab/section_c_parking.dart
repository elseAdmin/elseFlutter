import 'dart:collection';

import 'package:else_app_two/models/sensor_model.dart';
import 'package:else_app_two/parkingTab/parkingElements/parking_slot.dart';
import 'package:flutter/material.dart';

class SectionCParking extends StatefulWidget{
  final HashMap<String, SensorModel> _sensorModelMap;
  final HashMap<String, bool> _userMap;
  final int factor;
  SectionCParking(this._sensorModelMap, this._userMap, this.factor);

  @override
  _SectionCParking createState() => _SectionCParking();
}

class _SectionCParking extends State<SectionCParking>{
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ParkingSlot(0, 'A8', widget.factor, 3, false),
              paddingRightData(),
              ParkingSlot(1, 'B8', widget.factor, 1, false),
              ParkingSlot(1, 'D8', widget.factor, 3, false),
              paddingRightData(),
              ParkingSlot(0, 'E8', widget.factor, 1, false),
            ],
          ),
          Row(
            children: <Widget>[
              ParkingSlot(1, 'A9', widget.factor, 3, false),
              paddingRightData(),
              ParkingSlot(0, 'B9', widget.factor, 1, false),
              ParkingSlot(0, 'D9', widget.factor, 3, false),
              paddingRightData(),
              ParkingSlot(0, 'E9', widget.factor, 1, false),
            ],
          ),
          paddingBottomData(),
          Row(
            children: <Widget>[
              Container(
                height: 40.0 * widget.factor,
                width: 60.0 * widget.factor,
                child: Center(
                  child: Text('ENTRY'),
                ),
              ),
              ParkingSlot(widget._sensorModelMap['sensor6'].value, widget._sensorModelMap['sensor6'].slot, widget.factor, 0, widget._userMap['sensor6']),
              ParkingSlot(widget._sensorModelMap['sensor7'].value, widget._sensorModelMap['sensor7'].slot, widget.factor, 0, widget._userMap['sensor7']),
              ParkingSlot(widget._sensorModelMap['sensor8'].value, widget._sensorModelMap['sensor8'].slot, widget.factor, 0, widget._userMap['sensor8']),
              ParkingSlot(widget._sensorModelMap['sensor9'].value, widget._sensorModelMap['sensor9'].slot, widget.factor, 0, widget._userMap['sensor9']),
              ParkingSlot(widget._sensorModelMap['sensor10'].value, widget._sensorModelMap['sensor10'].slot, widget.factor, 0, widget._userMap['sensor10']),
              Container(
                height: 40.0 * widget.factor,
                width: 60.0 * widget.factor,
                child: Center(
                  child: Text('EXIT'),
                ),
              ),
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