import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingModel {
  int timestamp;
  DateTime date;
  DateTime parkingInTime, parkingOutTime;
  int major;
  int minor;
  String sensorName;
  ParkingModel(DocumentSnapshot snapshot) {
    if (snapshot != null) {
      this.timestamp = snapshot.data['parkingInTime'];
      this.parkingInTime =
          DateTime.fromMillisecondsSinceEpoch(snapshot.data['parkingInTime']);
      this.date =
          DateTime.fromMillisecondsSinceEpoch(snapshot.data['parkingInTime']);
      this.parkingOutTime =
          DateTime.fromMillisecondsSinceEpoch(snapshot.data['parkingOutTime']);
      this.major = snapshot.data['major'];
      this.minor = snapshot.data['minor'];
      this.sensorName = snapshot.data['proxiName'];
    }
  }
}
