import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/user_model.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:flutter/material.dart';

class UserCrudModel extends ChangeNotifier{
  String collection;

  UserCrudModel(this.collection, this._api);

  Api _api ;

  List<User> users;

  Future<List<User>> fetchUsers() async {
    var result = await _api.getDataCollection();
    users = result.documents
    .map((doc) => User.fromMap(doc.data, doc.documentID))
    .toList();
    return users;
  }

  Stream<QuerySnapshot> fetchUsersAsStream () {
    return _api.streamDataCollection();
  }

  Future<User> getUserById(String id) async{
    if(id.isEmpty){
      return null;
    }
    var doc = await _api.getDocumentById(id);
    if(doc.data == null){
      return null;
    }
    return User.fromMap(doc.data, doc.documentID);
  }

  Future removeUser(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }

  Future updateUser(User data, String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addUser(User data) async{
    var result  = await _api.addDocument(data.toJson()) ;
    return result.documentID;
  }

  Future addUserById(User data) async{
    var result = await _api.addDocumentById(data.id, data.toJson());
    return ;
  }
}