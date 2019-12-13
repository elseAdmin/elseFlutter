import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/base_model.dart';

class LocationEventSubmissionModel extends BaseModel {
  DateTime participatedAt;
  Timestamp date;
  String status;
  LocationEventSubmissionModel(DocumentSnapshot snapshot){
    if(snapshot!=null) {
      this.participatedAt = DateTime.fromMillisecondsSinceEpoch(snapshot.data['participatedAt']);
      this.date = snapshot.data['date'];
      this.status = snapshot.data['status'];
    }
  }
}