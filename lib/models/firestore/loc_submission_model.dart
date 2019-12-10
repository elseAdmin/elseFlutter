import 'package:cloud_firestore/cloud_firestore.dart';

class LocationEventSubmissionModel {
  var timestamp;
  var date;
  var status;
  LocationEventSubmissionModel(DocumentSnapshot snapshot){
    if(snapshot!=null) {
      this.timestamp = snapshot.data['participatedAt'];
      this.date = snapshot.data['date'];
      this.status = snapshot.data['status'];
    }
  }
}