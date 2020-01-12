import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/parkingTab/section_container.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'models/user_parking_model.dart';

class ParkingUIScreen extends StatefulWidget{
  final ParkingModel parkingModel;
  ParkingUIScreen(this.parkingModel);

  @override
  _ParkingUIScreen createState() => _ParkingUIScreen();
}

class _ParkingUIScreen extends State<ParkingUIScreen>{
  List<String> _floorLevel = ['Level -1', 'Level 0', 'Level 1', 'Level 2']; // Option 2
  String _selectedLocation = 'Level 0';
  bool _isUserParked = false;
  ParkingModel parking;


  @override
  void initState() {
    super.initState();
    bool isUserParked;
    if(widget.parkingModel != null){
      isUserParked = true;
    }
    else{
      isUserParked = false;
    }
    setState(() {
      _isUserParked = isUserParked;
      parking = widget.parkingModel;
    });
  }

  void _parkedVehicle(bool isUserParked){
    DatabaseManager().getActiveParking(StartupData.userid).then((model){
      setState(() {
        parking = model;
        _isUserParked = isUserParked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        textTheme: Typography.blackMountainView,
        title: Container(
          margin: EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton(
                hint: Text('Floor Level'), // Not necessary for Option 1
                value: _selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },
                items: _floorLevel.map((location) {
                  return DropdownMenuItem(
                    child: new Text(location),
                    value: location,
                  );
                }).toList(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 16.0,
                        width: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        margin: EdgeInsets.only(right: 10.0,top: 5.0),
                      ),
                      Text('Empty '),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 16.0,
                        width: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange[200],
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        margin: EdgeInsets.only(right: 10.0,top: 5.0),
                      ),
                      Text('Filled '),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        minHeight: 80.0,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        collapsed: collapsedPanelData(),
        panel: slidingPanelData(),
        body: Container(
          color: Colors.white,
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Container(
            margin: new EdgeInsets.all(10.0),
            child: SectionContainer(_parkedVehicle),
          ),
        ),
      ),
    );
  }

  Widget collapsedPanelData(){
    if(_isUserParked && parking.sensorName != null){
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_up),
            richTextData('Vehicle is parked',parking.sensorName),
          ],
        ),
      );
    } else {
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_up),
            richTextData('Vacant on this Floor','49'),
            richTextData('Total on this Floor','204'),
          ],
        ),
      );
    }
  }

  Widget slidingPanelData(){
    if(_isUserParked && parking.sensorName != null){
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_down),
            richTextData('Your vehicle is parked at',parking.parkingInTime.toIso8601String()),
            richTextData('At level','1'),
            richTextData('Row','B12'),
          ],
        ),
      );
    }
    else{
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_down),
            richTextData('Vacant on this Floor','42'),
            richTextData('Total on this Floor','204'),
          ],
        ),
      );
    }
  }

  Widget richTextData(String heading, String data){
    return RichText(
      text: TextSpan(
          text: '$heading : ',
          style: TextStyle(
              color: Constants.textColor,
              fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(text: '$data',
              style: TextStyle(
                  color: Constants.textColor,
                  fontWeight: FontWeight.w400
              ),
            ),
          ]
      ),
    );
  }

}