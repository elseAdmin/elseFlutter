import 'dart:collection';

import 'package:else_app_two/models/sensor_model.dart';
import 'package:else_app_two/parkingElements/lobby.dart';
import 'package:else_app_two/parkingElements/parking_slot.dart';
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
    return Column(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                ParkingSlot(1, 'A4', widget.factor, 3, false),
                ParkingSlot(1, 'A5', widget.factor, 3, false),
                ParkingSlot(1, 'A6', widget.factor, 3, false),
              ],
            ),
            Container(width: 40,height: 75,child: IconButton(icon: Icon(Icons.arrow_upward),),),
            Lobby(),
            Container(width: 40,height: 75,child: IconButton(icon: Icon(Icons.arrow_downward),),),
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
            ParkingSlot(1, 'A7', widget.factor, 3, false),
            paddingRightData(),
            ParkingSlot(0, 'B7', widget.factor, 1, false),
            ParkingSlot(0, 'D7', widget.factor, 3, false),
            paddingRightData(),
            ParkingSlot(0, 'E7', widget.factor, 1, false),
          ],
        ),
      ],
    );
  }

  Widget paddingBottomData(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
    );
  }

  Widget paddingRightData(){
    return Padding(
      padding: const EdgeInsets.only(right: 40.0),
    );
  }

}