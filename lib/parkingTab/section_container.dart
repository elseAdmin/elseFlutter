import 'dart:async';
import 'dart:collection';

import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/models/sensor_model.dart';
import 'package:else_app_two/parkingTab/section_a_parking.dart';
import 'package:else_app_two/parkingTab/section_b_parking.dart';
import 'package:else_app_two/parkingTab/section_c_parking.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool);

class SectionContainer extends StatefulWidget{
  final BoolCallback onParkedVehicle;
  SectionContainer(this.onParkedVehicle);

  @override
  _SectionContainer createState() => _SectionContainer();
}

class _SectionContainer extends State<SectionContainer>{
  int factor = 1;
  String currentUser;

  HashMap<String, SensorModel> _sensorModelMap = new HashMap();
  HashMap<String, bool> _userMap = new HashMap();
  FireBaseApi _fireBaseApi = FireBaseApi("parking");
  var _sensorStream = StreamController<String>();
//  PanelController _panelController = new PanelController();

  @override
  Future didChangeDependencies() async{
    super.didChangeDependencies();
    final BaseAuth _auth = AuthProvider.of(context).auth;
    currentUser = await _auth.currentUser();
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
      if(sensorModelMap[sensor].userUid == currentUser){
        userMap[sensor] = true;
        widget.onParkedVehicle(true);
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
        if(sensorModel.userUid == StartupData.user.id){
          _userMap[sensorModel.name] = true;
          widget.onParkedVehicle(true);
        } else{
          _userMap[sensorModel.name] = false;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getDataUpdate();
  }

  compareData(SensorModel oldData, SensorModel newData){
    if(oldData.value == newData.value && oldData.userUid == newData.userUid){
      return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
//        height: MediaQuery.of(context).size.height / 10 * 4,
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
        child: FittedBox(
          alignment: Alignment.center,
          child: StreamBuilder(
            stream: _sensorStream.stream,
            builder: (context, asyncSnapshot){
              if(asyncSnapshot.hasData){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SectionAParking(_sensorModelMap,_userMap,factor),
                    SectionBParking(_sensorModelMap, _userMap, factor),
                    SectionCParking(_sensorModelMap, _userMap, factor),
                    Container(height: 200.0)
                  ],
                );
              } else {
                return Container(child: Center(child: Text('Loading data'),),);
              }
            },
          ),
        ),
      ),
    );
  }

}