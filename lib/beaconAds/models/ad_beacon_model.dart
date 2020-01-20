import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/utils/app_startup_data.dart';

class AdBeacon{
  String imageUrl;
  String status;
  List allowedUsers;
  String major,minor;
  String shopUid;

  AdBeacon(DocumentSnapshot snapshot){
    this.imageUrl = snapshot.data['imageUrl'];
    this.status = snapshot.data['status'];
    this.allowedUsers = snapshot.data['allowedUsers'];
    this.shopUid = snapshot.data['shopUid'];
  }

  bool isUserAllowed(){
    if(this.allowedUsers.contains(StartupData.user.id) || this.allowedUsers.contains("all")){
      return true;
    }
    return false;
  }
}