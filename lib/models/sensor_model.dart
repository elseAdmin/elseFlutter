import 'package:firebase_database/firebase_database.dart';

class SensorModel{
  int major;
  int minor;
  String name;
  String slot;
  DateTime updatedAt;
  String userUid;
  int value;

  SensorModel(this.major, this.minor, this.name, this.slot, this.updatedAt,
      this.userUid, this.value);

  SensorModel.fromSnapshot(DataSnapshot snapshot){
    major = snapshot.value['major'] ?? '';
    minor = snapshot.value['minor'] ?? '';
    name = snapshot.value['name'] ?? '';
    slot = snapshot.value['slot'] ?? '';
    updatedAt = DateTime.parse(snapshot.value['updatedAt'].toString());
    userUid = snapshot.value['userUid'] ?? '';
    value = snapshot.value['value'] ?? 0;
  }

  SensorModel.fromMap(Map snapshot){
    major = snapshot['major'] ?? '';
    minor = snapshot['minor'] ?? '';
    name = snapshot['name'] ?? '';
    slot = snapshot['slot'] ?? '';
    updatedAt = DateTime.parse(snapshot['updatedAt'].toString());
    userUid = snapshot['userUid'] ?? '';
    value = snapshot['value'] ?? 0;
  }
}