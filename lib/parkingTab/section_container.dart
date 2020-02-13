import 'dart:async';
import 'dart:collection';
import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/models/sensor_model.dart';
import 'package:else_app_two/parkingTab/section_a_parking.dart';
import 'package:else_app_two/parkingTab/section_b_parking.dart';
import 'package:else_app_two/parkingTab/section_c_parking.dart';
import 'package:else_app_two/service/beacon_service.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool);

class SectionContainer extends StatefulWidget{
  final BoolCallback onParkedVehicle;
  final VoidCallback outParking;
  SectionContainer(this.onParkedVehicle, this.outParking);

  @override
  _SectionContainer createState() => _SectionContainer();
}

class _SectionContainer extends State<SectionContainer>{
  int zoomFactor = 1;
  String currentUser = '';

  ScrollController _horizontalController, _verticalController;
  double _windowWidth, _windowHeight;
  BeaconServiceImpl _beaconServiceImpl;

  HashMap<String, SensorModel> _sensorModelMap = new HashMap();
  HashMap<String, bool> _userMap = new HashMap();
  FireBaseApi _fireBaseApi = FireBaseApi("parking");
  var _sensorStream = StreamController<String>();

  @override
  Future didChangeDependencies() async{
    super.didChangeDependencies();

    _windowWidth = SizeConfig.blockSizeHorizontal*90 /2;
    _windowHeight = SizeConfig.blockSizeVertical/4;

    HashMap<String, SensorModel> sensorModelMap = new HashMap();
    HashMap<String, bool> userMap = new HashMap();
    var sensorStream = StreamController<String>();
    var results = await _fireBaseApi.getDataSnapshot();
    List sensorNameList = results.value.keys.toList();
    Map<dynamic, dynamic> values = results.value;

    for(String sensor in sensorNameList){
      SensorModel sensorModel = SensorModel.fromMap(values[sensor]);
      sensorModelMap[sensor] = sensorModel;
      userMap[sensor] = false;
      if(sensorModelMap[sensor].userUid == StartupData.user.id){
        userMap[sensor] = true;
        widget.onParkedVehicle(true);
        currentUser = sensorModelMap[sensor].userUid;
      }
      sensorStream.add(sensor);
    }
    setState(() {
      _sensorModelMap = sensorModelMap;
      _userMap = userMap;
      _sensorStream = sensorStream;
      sensorStream.close();
    });
  }

  getDataUpdate(){
    _fireBaseApi.getReference().onChildChanged.listen(onChangeData);
  }

  onChangeData(Event event){
    SensorModel sensorModel = SensorModel.fromSnapshot(event.snapshot);
    bool changeData = compareData(_sensorModelMap[sensorModel.name], sensorModel);
    setState(() {
      if(changeData){
        _sensorModelMap[sensorModel.name] = sensorModel;
        if(sensorModel.value == 1 && sensorModel.userUid == StartupData.user.id){
          //when parking is stamped for user, do not mark more parking visit.
          Constants.parkingEligibleUser=false;
          _userMap[sensorModel.name] = true;
          currentUser = _sensorModelMap[sensorModel.name].userUid;
          widget.onParkedVehicle(true);
        } else if (sensorModel.value == 0 && sensorModel.userUid == currentUser){
          currentUser = '';
          _userMap[sensorModel.name] = false;
          widget.outParking();
        } else{
          _userMap[sensorModel.name] = false;
        }
      }
    });
  }

  jumpSection(int sectionValue){
    print("jump to section "+sectionValue.toString());
    if(sectionValue == -1){
      _verticalController.animateTo(0, duration: Duration(milliseconds: 500),
          curve: Curves.linear);
      _horizontalController.animateTo(0, duration: Duration(milliseconds: 500),
          curve: Curves.linear);
      zoomFactor = 1;
    }
    else if((sectionValue % 2) == 0){
      _verticalController.animateTo(_windowHeight * ((sectionValue/2) - 1), duration: Duration(milliseconds: 500),
          curve: Curves.linear);
      _horizontalController.animateTo(_windowWidth * 1, duration: Duration(milliseconds: 500),
          curve: Curves.linear);
      zoomFactor = 1;
    }
    else {
      double height = _windowHeight * (sectionValue/2);
      print('height aayi h $height');
      _verticalController.animateTo(height, duration: Duration(milliseconds: 500),
          curve: Curves.linear);
      _horizontalController.animateTo(_windowWidth * 0, duration: Duration(milliseconds: 500),
          curve: Curves.linear);
      zoomFactor = 1;
    }
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getDataUpdate();
    _verticalController = ScrollController();
    _horizontalController = ScrollController();
    _beaconServiceImpl = BeaconServiceImpl.parkingConstructor(jumpSection);
  }

  compareData(SensorModel oldData, SensorModel newData){
    if(oldData.value == newData.value && oldData.userUid == newData.userUid){
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _sensorStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _horizontalController,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
              Radius.circular(5.0)
          ),
        ),
        child: StreamBuilder(
          stream: _sensorStream.stream,
          builder: (context, asyncSnapshot){
            if(asyncSnapshot.hasData){
              return SizedBox(
                width: (SizeConfig.blockSizeHorizontal*90) * zoomFactor,
                child: ListView(
                  controller: _verticalController,
                  children: <Widget>[
                    SectionAParking(_sensorModelMap,_userMap, zoomFactor),
                    SectionBParking(_sensorModelMap, _userMap, zoomFactor),
                    SectionCParking(_sensorModelMap, _userMap, zoomFactor),
                    Container(height: 300.0 * zoomFactor),
                  ],
                ),
              );
            } else {
              return Container(child: Center(child: Text('Loading data'),),);
            }
          },
        ),
      ),
    );
  }

}

