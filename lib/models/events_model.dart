import 'package:firebase_database/firebase_database.dart';

import 'base_model.dart';

class EventModel extends BaseModel{
  String description;
  DateTime startDate;
  DateTime endDate;
  final String Heading = "Events";

  EventModel(DataSnapshot snapshot):super(snapshot){
    this.description = snapshot.value['description'];
    //parse dates
  }
}