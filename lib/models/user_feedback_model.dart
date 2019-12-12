import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedBack{

  String id;
  String feedbackId;
  String universe;
  String subject;
  int feedbackStatus;
  Timestamp createdDate;
  Timestamp updatedDate;

  UserFeedBack(this.feedbackId, this.universe, this.subject,
      this.feedbackStatus, this.createdDate, this.updatedDate);

  UserFeedBack.fromMap(Map snapshot, String id) :
      id = id ?? '',
      subject = snapshot['subject'] ?? '',
      feedbackId = snapshot['feedbackId'] ?? '',
      universe = snapshot['universe'] ?? '',
      feedbackStatus = snapshot['feedbackStatus'] ?? '',
      createdDate = snapshot['createdDate'] ?? '',
      updatedDate = snapshot['updatedDate'] ?? '';

  toJson(){
    return{
      "subject":subject,
      "feedbackId":feedbackId,
      "universe":universe,
      "feedbackStatus":feedbackStatus,
      "createdDate":createdDate,
      "updatedDate":updatedDate
    };
  }


}