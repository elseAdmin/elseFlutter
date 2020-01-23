import 'package:cloud_firestore/cloud_firestore.dart';

class UserDealModel {
  int timestamp;
  DateTime date;
  String universe;
  String imageUrl;
  String shopUid;

  UserDealModel(DocumentSnapshot snapshot){
    if(snapshot!=null) {
      this.date = DateTime.fromMillisecondsSinceEpoch(snapshot.data['timestamp']);
      this.timestamp =snapshot.data['timestamp'];
      this.universe = snapshot.data['universe'];
      this.imageUrl = snapshot.data['imageUrl'];
      this.shopUid = snapshot.data['shopUid'];
    }
  }
}