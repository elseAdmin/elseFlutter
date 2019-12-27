import 'package:cloud_firestore/cloud_firestore.dart';

class UserRequestModal{
  String url;
  DateTime timestamp;
  String universe;
  UserRequestModal(DocumentSnapshot doc){
    if(doc!=null){
      this.url =doc.data['requestUrl'];
      this.timestamp = DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp']);
      this.universe = doc.data['universe'];
    }
  }
}