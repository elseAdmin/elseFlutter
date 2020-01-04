class User{

  String id;
  String phoneNumber;
  String name;
  String email;

  User(this.id, this.phoneNumber, this.name, this.email);

  User.fromMap(Map snapshot, String id) :
      id = id ?? '',
      phoneNumber = snapshot['phoneNumber'] ?? '',
      name = snapshot['name'] ?? '',
      email = snapshot['email'] ?? '';

  toJson(){
    return{
      "name":name,
      "phoneNumber":phoneNumber,
      "email":email
    };
  }

}