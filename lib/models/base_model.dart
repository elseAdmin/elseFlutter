import 'package:firebase_database/firebase_database.dart';

class BaseModel{
  String id;
  String url;
  String blurUrl;
  String name;
  String status;
  String uid;
  BaseModel(DataSnapshot snapshot){
    this.id = snapshot.key;
    this.url = snapshot.value['url'];
    this.name = snapshot.value['name'];
    this.status = snapshot.value['status'];
    this.blurUrl=snapshot.value['blurUrl'];
    this.uid=snapshot.value['uid'];
  }
}