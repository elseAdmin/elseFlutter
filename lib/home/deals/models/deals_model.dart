import 'package:firebase_database/firebase_database.dart';

class DealModel {
  List tnc;
  DateTime validity;
  String shopName;
  String url;
  String blurUrl;
  String name;
  String shortDetails;
  List details;
  String status;
  String uid;
  String couponCode;

  DealModel(this.tnc, this.validity, this.shopName, this.url,
      this.blurUrl, this.name, this.shortDetails, this.details, this.status,
      this.uid, this.couponCode);

  DealModel.fromMap(Map snapshot)
      : this.tnc = snapshot['tnc'],
        this.validity = DateTime.fromMillisecondsSinceEpoch(snapshot['validity']),
        this.shopName = snapshot['shopName'],
        this.shortDetails = snapshot['shortDetails'],
        this.details = snapshot['details'],
        this.url = snapshot['url'],
        this.name = snapshot['name'],
        this.status = snapshot['status'],
        this.blurUrl = snapshot['blurUrl'],
        this.uid = snapshot['uid'],
        this.couponCode = snapshot['couponCode'];

  DealModel.fromSnapshot(DataSnapshot snapshot) {
    this.tnc = snapshot.value['tnc'];
    this.shopName = snapshot.value['shopName'];
    this.validity = DateTime.fromMillisecondsSinceEpoch(snapshot.value['validity']);
    this.shortDetails = snapshot.value['shortDetails'];
    this.details = snapshot.value['details'];
    this.url = snapshot.value['url'];
    this.name = snapshot.value['name'];
    this.status = snapshot.value['status'];
    this.blurUrl = snapshot.value['blurUrl'];
    this.uid = snapshot.value['uid'];
    this.couponCode = snapshot.value['couponCode'];
  }

  toJson(){
    return {
      "tnc":tnc,
      "shopName":shopName,
      "validity":validity.millisecondsSinceEpoch,
      "shortDetails":shortDetails,
      "details":details,
      "url":url,
      "name":name,
      "status":status,
      "blurUrl":blurUrl,
      "uid":uid,
      "couponCode":couponCode,
    };
  }
}
