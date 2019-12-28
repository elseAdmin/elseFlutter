import 'package:cloud_firestore/cloud_firestore.dart';

class UserRequestModal{
  String url;
  DateTime date;
  int timestamp;
  String universe;
  UserRequestModal(DocumentSnapshot doc){
    if(doc!=null){
      this.url =doc.data['requestUrl'];
      this.date = DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp']);
      this.timestamp = doc.data['timestamp'];
      this.universe = doc.data['universe'];
    }
  }
}