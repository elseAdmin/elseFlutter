import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/base_model.dart';

class OfflineEventSubmissionModel extends BaseModel{
  String participationId;
  DateTime participatedAt;
  OfflineEventSubmissionModel(DocumentSnapshot snapshot) {
    if (snapshot != null) {
      this.participationId = snapshot.data['participationId'];
      this.participatedAt = DateTime.fromMillisecondsSinceEpoch(snapshot.data['participatedAt']);
    }
  }
}
