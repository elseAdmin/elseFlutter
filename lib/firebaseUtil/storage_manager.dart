import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'database_manager.dart';

class StorageManager{
  StorageReference ref;
  DatabaseManager databaseManager = DatabaseManager();
  FirebaseStorage _storage;
  final String path;

  StorageManager(this.path){
    _storage = databaseManager.getStorageReference();
    ref = _storage.ref().child(path);
  }

  void addFilePath(String path){
    ref = _storage.ref().child(path);
  }

  Future<StorageTaskSnapshot> getStorageSnapshot(File image) async{
    final StorageUploadTask uploadTask = ref.putFile(
      image,
      StorageMetadata(
        contentType: "image" + '/' + "jpeg",
      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    return downloadUrl;
  }

  Future<String> uploadImageUrl(File image) async{
    final StorageUploadTask uploadTask = ref.putFile(
      image,
      StorageMetadata(
        contentType: "image" + '/' + "jpeg",
      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  Future removeImageUrl() async{
    await ref.delete();
    return;
  }
}