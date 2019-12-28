class Request{

  String id;
  String phoneNumber;
  String name;
  String message;
  String uid;

  Request(this.phoneNumber, this.name, this.message, this.uid);

  Request.fromMap(Map snapshot, String id) :
        id = id ?? '',
        phoneNumber = snapshot['phoneNumber'] ?? '',
        name = snapshot['name'] ?? '',
        message = snapshot['message'] ?? '',
        uid = snapshot['uid'] ?? '';

  toJson(){
    return{
      "name":name,
      "phoneNumber":phoneNumber,
      "messsage":message,
      "uid":uid,
      "timestamp":DateTime.now().millisecondsSinceEpoch
    };
  }
}