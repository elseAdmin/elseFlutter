import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSubmissionModel {
  String imageUrl;
  int likes;
  String status;
  String userUid;

  FirestoreSubmissionModel(DocumentSnapshot snapshot) {
    this.imageUrl = snapshot.data["imageUrl"];
    this.likes = snapshot.data["likes"];
    this.status = snapshot.data["status"];
    this.userUid = snapshot.data["userUid"];
  }
}
