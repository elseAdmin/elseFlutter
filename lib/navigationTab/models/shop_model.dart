import 'package:firebase_database/firebase_database.dart';

class ShopModel{

  String name;
  String about;
  int floor;
  String shopNo;
  List category;
  String openTime;
  String closeTime;
  String contactInfo;
  String imageUrl;

  ShopModel(DataSnapshot snapshot){
    name = snapshot.value['name'] ?? '';
    about = snapshot.value['about'] ?? '';
    floor = snapshot.value['floor'] ?? '';
    shopNo = snapshot.value['shopNo'] ?? '';
    category = snapshot.value['category'] ?? {};
    openTime = snapshot.value['openTime'] ?? '';
    closeTime = snapshot.value['closeTime'] ?? '';
    contactInfo = snapshot.value['contactInfo'] ?? '';
    imageUrl = snapshot.value['imageUrl'] ?? '';
  }

  ShopModel.fromMap(Map snapshot){
    name = snapshot['name'] ?? '';
    about = snapshot['about'] ?? '';
    floor = snapshot['floor'] ?? '';
    shopNo = snapshot['shopNo'] ?? '';
    category = snapshot['category'] ?? {};
    openTime = snapshot['openTime'] ?? '';
    closeTime = snapshot['closeTime'] ?? '';
    contactInfo = snapshot['contactInfo'] ?? '';
    imageUrl = snapshot['imageUrl'] ?? '';
  }

}