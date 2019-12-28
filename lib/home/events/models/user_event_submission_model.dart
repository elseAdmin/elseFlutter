import 'package:cloud_firestore/cloud_firestore.dart';

class UserEventSubmissionModel {
  String eventUrl;
  String submissionUrl;
  int timestamp;
  String eventName;

  UserEventSubmissionModel(DocumentSnapshot doc) {
    if (doc != null) {
      this.eventName = doc.data['eventName'];
      this.eventUrl = doc.data['eventUrl'];
      this.submissionUrl = doc.data['submissionUrl'];
      this.timestamp = doc.data['timestamp'];
    }
  }
}
