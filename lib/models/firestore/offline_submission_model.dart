import 'package:cloud_firestore/cloud_firestore.dart';

class OfflineEventSubmissionModel {
  String participationId;
  int timestamp;
  OfflineEventSubmissionModel(DocumentSnapshot snapshot) {
    if (snapshot != null) {
      this.participationId = snapshot.data['participationId'];
      this.timestamp = snapshot.data['participatedAt'];
    }
  }
}
