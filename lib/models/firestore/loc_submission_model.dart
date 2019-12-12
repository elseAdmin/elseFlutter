import 'package:cloud_firestore/cloud_firestore.dart';

class LocationEventSubmissionModel {
  int timestamp;
  Timestamp date;
  String status;
  LocationEventSubmissionModel(DocumentSnapshot snapshot){
    if(snapshot!=null) {
      this.timestamp = snapshot.data['participatedAt'];
      this.date = snapshot.data['date'];
      this.status = snapshot.data['status'];
    }
  }
}