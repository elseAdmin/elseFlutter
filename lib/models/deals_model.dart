import 'package:else_app_two/Models/base_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DealModel extends BaseModel{
  String tnc;
  String validity;

  String id;
  String url;
  String blurUrl;
  String name;
  String status;
  String uid;

  DealModel(DataSnapshot snapshot){
    this.tnc = snapshot.value['tnc'];
    this.validity = snapshot.value['validity'];

    this.id = snapshot.key;
    this.url = snapshot.value['url'];
    this.name = snapshot.value['name'];
    this.status = snapshot.value['status'];
    this.blurUrl=snapshot.value['blurUrl'];
    this.uid=snapshot.value['uid'];
  }
}