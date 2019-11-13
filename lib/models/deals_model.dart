import 'package:else_app_two/Models/base_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DealModel extends BaseModel{
  String tnc;
  String validity;
  DealModel(DataSnapshot snapshot) : super(snapshot){
    this.tnc = snapshot.value['tnc'];
    this.validity = snapshot.value['validity'];
  }
}