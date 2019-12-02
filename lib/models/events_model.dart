import 'package:firebase_database/firebase_database.dart';

import 'base_model.dart';

class EventModel extends BaseModel{
  String description;
  String type;
  DateTime startDate;
  DateTime endDate;
  String rules;
  int totalRules;
  String id;
  String url;
  String blurUrl;
  String name;
  String status;
  String uid;

  EventModel(DataSnapshot snapshot){
    this.description = snapshot.value['description'];
    this.startDate = DateTime.parse(snapshot.value['startDate']);
    this.endDate = DateTime.parse(snapshot.value["endDate"]);
    this.rules = snapshot.value['rules'];
    this.type = snapshot.value['type'];

    this.id = snapshot.key;
    this.url = snapshot.value['url'];
    this.name = snapshot.value['name'];
    this.status = snapshot.value['status'];
    this.blurUrl=snapshot.value['blurUrl'];
    this.uid=snapshot.value['uid'];
  }
}