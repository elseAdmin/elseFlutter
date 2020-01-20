import 'package:firebase_database/firebase_database.dart';

class DealModel {
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
  String shopName;

  DealModel.fromMap(Map snapshot)
      : this.tnc = snapshot['tnc'],
        this.validity = snapshot['validity'],
        this.shortDetails = snapshot['shortDetails'],
        this.details = snapshot['details'],
        this.url = snapshot['url'],
        this.name = snapshot['name'],
        this.status = snapshot['status'],
        this.blurUrl = snapshot['blurUrl'],
        this.uid = snapshot['uid'],
        this.couponCode = snapshot['couponCode'],
        this.shopName = snapshot['shopName'];

  DealModel(DataSnapshot snapshot) {
    this.tnc = snapshot.value['tnc'];
    this.validity = snapshot.value['validity'];
    this.shortDetails = snapshot.value['shortDetails'];
    this.details = snapshot.value['details'];
    this.id = snapshot.key;
    this.url = snapshot.value['url'];
    this.name = snapshot.value['name'];
    this.status = snapshot.value['status'];
    this.blurUrl = snapshot.value['blurUrl'];
    this.uid = snapshot.value['uid'];
    this.couponCode = snapshot.value['couponCode'];
    this.shopName = snapshot.value['shopName'];
  }
}
