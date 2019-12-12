import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/base_model.dart';

class FirestoreSubmissionModel extends BaseModel{
  String imageUrl;
  int likes;
  String status;
  String userUid;

  FirestoreSubmissionModel(DocumentSnapshot snapshot){
    this.imageUrl = snapshot.data["imageUrl"];
    this.likes = snapshot.data["likes"];
    this.status = snapshot.data["status"];
    this.userUid = snapshot.data["userUid"];
  }
}
