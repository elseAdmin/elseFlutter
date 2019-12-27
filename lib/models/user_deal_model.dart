import 'package:cloud_firestore/cloud_firestore.dart';

class UserDealModel {
  int timestamp;
  String universe;
  String imageUrl;
  UserDealModel(DocumentSnapshot snapshot){
    if(snapshot!=null) {
      this.timestamp =snapshot.data['timestamp'];
      this.universe = snapshot.data['universe'];
      this.imageUrl = snapshot.data['imageUrl'];
    }
  }
}