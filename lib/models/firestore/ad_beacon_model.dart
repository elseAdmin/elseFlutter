import 'package:cloud_firestore/cloud_firestore.dart';

class AdBeacon{
  String imageUrl;
  String status;
  List<String> allowedUsers;

  AdBeacon(DocumentSnapshot snapshot){
    this.imageUrl = snapshot.data['imageUrl'];
    this.status = snapshot.data['status'];
    this.allowedUsers = snapshot.data['allowedUsers'];
  }
}