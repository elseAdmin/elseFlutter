import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/utils/app_startup_data.dart';

class AdBeacon{
  String imageUrl;
  String status;
  List allowedUsers;
  String major,minor;

  AdBeacon(DocumentSnapshot snapshot){
    this.imageUrl = snapshot.data['imageUrl'];
    this.status = snapshot.data['status'];
    this.allowedUsers = snapshot.data['allowedUsers'];
  }

  bool isUserAllowed(){
    if(this.allowedUsers.contains(StartupData.userid) || this.allowedUsers.contains("all")){
      return true;
    }
    return false;
  }
}