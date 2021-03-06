import 'package:else_app_two/basicElements/qr_scanner.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/navigationBarScreens/home_screen.dart';
import 'package:else_app_two/navigationBarScreens/parking_screen.dart';
import 'package:else_app_two/parkingTab/section_container.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:zoom_widget/zoom_widget.dart';

import 'models/user_parking_model.dart';

class ParkingUIScreen extends StatefulWidget {
  final ParkingModel parkingModel;
  final VoidCallback outParking;
  ParkingUIScreen(this.parkingModel, this.outParking);

  @override
  _ParkingUIScreen createState() => _ParkingUIScreen();
}

class _ParkingUIScreen extends State<ParkingUIScreen> {
  List<String> _floorLevel = [
    'Level -1',
    'Level 0',
    'Level 1',
    'Level 2'
  ]; // Option 2
  String _selectedLocation = 'Level 0';
  bool _isUserParked = false;
  bool _isScanned = true;
  ParkingModel parking;

  void _outParking() {
//    Navigator.pop(context);
    setState(() {
      parking = ParkingModel(null);
    });
    widget.outParking();
  }

  @override
  void initState() {
    super.initState();
    bool isUserParked;
    if (widget.parkingModel != null) {
      isUserParked = true;
    } else {
      isUserParked = false;
    }
    if(Constants.hasScannedForParking){
      _isScanned = true;
    }
    setState(() {
      _isUserParked = isUserParked;
      parking = widget.parkingModel;
    });
  }

  void _parkedVehicle(bool isUserParked) {
    DatabaseManager().getActiveParking().then((model) {
      setState(() {
        parking = model;
        _isUserParked = isUserParked;
      });
    });
  }

  _redirectToQRScan(){
    setState(() {
      _isScanned = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_isScanned){
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            textTheme: Typography.blackMountainView,
            title: SizedBox(
//          margin: EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DropdownButton(
                    hint: Text('Level 0'), // Not necessary for Option 1
                    value: _selectedLocation,
                    //TODO floor has been fixed as we don't have many floor map
                    /*onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },*/
                    items: _floorLevel.map((location) {
                      return DropdownMenuItem(
                        child: new Text(location),
                        value: location,
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 16.0,
                        width: 16.0,
                        decoration: BoxDecoration(
                          color: Constants.vacantSpace,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      Text(' Empty '),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 16.0,
                        width: 16.0,
                        decoration: BoxDecoration(
                          color: Constants.parkedVehicle,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      Text(' Filled '),
                    ],
                  ),
                  FlatButton(
                    onPressed: Constants.inRangeForParking && !Constants.hasScannedForParking ? _redirectToQRScan : null,
                    child: Text(
                      'SCAN',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
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
                  child: SectionContainer(_parkedVehicle, _outParking),
                ),
              )
          )
      );
    } else {
      return QrScanner(_outParking);
    }

  }

  Widget collapsedPanelData() {
    if (_isUserParked && parking.sensorName != null) {
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_up),
            richTextData('Vehicle is parked', parking.sensorName),
          ],
        ),
      );
    } else {
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_up),
            richTextData('Vacant on this Floor', '49'),
            richTextData('Total on this Floor', '204'),
          ],
        ),
      );
    }
  }

  Widget slidingPanelData() {
    if (_isUserParked && parking.sensorName != null) {
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_down),
            richTextData('Your vehicle is parked at',
                parking.parkingInTime.toIso8601String()),
            richTextData('At level', '1'),
            richTextData('Row', 'B12'),
          ],
        ),
      );
    } else {
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.keyboard_arrow_down),
            richTextData('Vacant on this Floor', '42'),
            richTextData('Total on this Floor', '204'),
          ],
        ),
      );
    }
  }

  Widget richTextData(String heading, String data) {
    return RichText(
      text: TextSpan(
          text: '$heading : ',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(
              text: '$data',
              style: TextStyle(
                  color: Constants.textColor, fontWeight: FontWeight.w400),
            ),
          ]),
    );
  }
}
