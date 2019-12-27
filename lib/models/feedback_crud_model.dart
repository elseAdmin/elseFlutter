import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/models/feedback_model.dart';
import 'package:flutter/cupertino.dart';

class FeedbackCrudModel extends ChangeNotifier{
  Api _api;

  FeedbackCrudModel(this._api);

  List<FeedBack> feedbackList;

  Future<List<FeedBack>> fetchFeedBacks() async {
    var result = await _api.getDataCollection();
    feedbackList = result.documents
    .map((doc) => FeedBack.fromMap(doc.data, doc.documentID))
    .toList();
    return feedbackList;
  }

  Stream<QuerySnapshot> fetchFeedBackAsStream () {
    return _api.streamDataCollection();
  }

  Future<FeedBack> getFeedBackById(String id) async{
    if(id.isEmpty){
      return null;
    }
    var doc = await _api.getDocumentById(id);
    if(doc.data == null){
      return null;
    }
    return FeedBack.fromMap(doc.data, doc.documentID);
  }

  Future removeFeedBack(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }

  Future updateFeedBack(FeedBack data, String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addFeedBack(FeedBack data) async{
    var result  = await _api.addDocument(data.toJson()) ;
    return result.path;
  }

  Future addFeedBackById(FeedBack data) async{
    var result = await _api.addDocumentById(data.id, data.toJson());
    return ;
  }

}