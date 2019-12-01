import 'package:firebase_database/firebase_database.dart';

import 'base_model.dart';

class EventModel extends BaseModel{
  String description;
  String type;
  DateTime startDate;
  DateTime endDate;
  String rules;
  int totalRules;
  final String Heading = "Events";

  EventModel(DataSnapshot snapshot):super(snapshot){
    this.description = snapshot.value['description'];
    this.startDate = DateTime.parse(snapshot.value['startDate']);
    this.endDate = DateTime.parse(snapshot.value["endDate"]);
    this.rules = snapshot.value['rules'];
    this.type = snapshot.value['type'];
  }
}