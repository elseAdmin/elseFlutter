import 'package:firebase_database/firebase_database.dart';

import 'base_model.dart';

class EventModel extends BaseModel{
  String id;
  String name;
  String description;
  String status;
  DateTime startDate;
  DateTime endDate;
  final String Heading = "Events";

  EventModel(DataSnapshot snapshot){
    this.id  = snapshot.key;
    this.url = snapshot.value['url'];
    this.name = snapshot.value['name'];
    this.description = snapshot.value['description'];
    this.status = snapshot.value['status'];
    //parse dates
  }
}