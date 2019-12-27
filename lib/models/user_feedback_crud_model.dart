import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/models/user_feedback_model.dart';
import 'package:flutter/cupertino.dart';

class UserFeedBackCrudModel extends ChangeNotifier{
  Api _api;

  UserFeedBackCrudModel(this._api);

  List<UserFeedBack> userFeedBackList;

  Future<List<UserFeedBack>> fetchUserFeedBackList() async {
    var result = await _api.getDataCollection();
    userFeedBackList = result.documents
    .map((doc) => UserFeedBack.fromMap(doc.data))
    .toList();
    return userFeedBackList;
  }

  Stream<QuerySnapshot> fetchUserFeedBackAsStream () {
    return _api.streamDataCollection();
  }

  Future<UserFeedBack> getUserFeedBackById(String id) async{
    if(id.isEmpty){
      return null;
    }
    var doc = await _api.getDocumentById(id);
    if(doc.data == null){
      return null;
    }
    return UserFeedBack.fromMap(doc.data);
  }

  Future removeUserFeedBack(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }

  Future updateUserFeedBack(UserFeedBack data, String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

   addUserFeedBack(UserFeedBack data) async{
    var result  = await _api.addDocument(data.toJson()) ;
  }


}