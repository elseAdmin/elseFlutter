import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/request_model.dart';
import 'package:else_app_two/service/api.dart';
import 'package:flutter/material.dart';

class RequestCrudModel extends ChangeNotifier{

  RequestCrudModel(this._api);

  Api _api ;

  List<Request> requests;

  Future<List<Request>> fetchRequests() async {
    var result = await _api.getDataCollection();
    requests = result.documents
    .map((doc) => Request.fromMap(doc.data, doc.documentID))
    .toList();
    return requests;
  }

  Stream<QuerySnapshot> fetchRequestsAsStream () {
    return _api.streamDataCollection();
  }

  Future<Request> getRequestById(String id) async{
    if(id.isEmpty){
      return null;
    }
    var doc = await _api.getDocumentById(id);
    if(doc.data == null){
      return null;
    }
    return Request.fromMap(doc.data, doc.documentID);
  }

  Future removeRequest(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }

  Future updateRequest(Request data, String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addRequest(Request data) async{
    var result  = await _api.addDocument(data.toJson()) ;
    return result.documentID;
  }

  Future addRequestById(Request data) async{
    var result = await _api.addDocumentById(data.id, data.toJson());
    return ;
  }
}