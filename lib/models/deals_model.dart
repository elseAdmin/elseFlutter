import 'package:else_app_two/Models/base_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DealModel extends BaseModel{
  List tnc;
  String validity;

  String id;
  String url;
  String blurUrl;
  String name;
  String shortDetails;
  List details;
  String status;
  String uid;
  String couponCode;

  DealModel(DataSnapshot snapshot){
    this.tnc = snapshot.value['tnc'];
    this.validity = snapshot.value['validity'];
    this.shortDetails = snapshot.value['shortDetails'];
    this.details = snapshot.value['details'];
    this.id = snapshot.key;
    this.url = snapshot.value['url'];
    this.name = snapshot.value['name'];
    this.status = snapshot.value['status'];
    this.blurUrl=snapshot.value['blurUrl'];
    this.uid=snapshot.value['uid'];
    this.couponCode=snapshot.value['couponCode'];
  }
}