import 'package:else_app_two/models/user_model.dart';
import 'package:else_app_two/service/api.dart';
import 'package:else_app_two/service/user_crud_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget{
  final String userId;
  final String phoneNumber;
  final VoidCallback onSignedIn;
  RegisterUser(this.userId, this.phoneNumber, this.onSignedIn);

  @override
  _RegisterUser createState() => _RegisterUser();

}

class _RegisterUser extends State<RegisterUser>{

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  void _registerUser(BuildContext context, String name, String email){
    final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));
    User user = new User(widget.userId, widget.phoneNumber, name, email);
    print('Phone number ' + widget.phoneNumber);
    Future userfuture = userProvider.addUserById(user);
    if(userfuture !=null){
      print('User registered successfully ' + userfuture.toString());
      Navigator.pop(context);
      widget.onSignedIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: new Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width * 2 / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixText: 'Mr./ Ms. ',
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Name';
                  }
                  return null;
                },
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Id'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.send,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.center,
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width / 2,
                  child: RaisedButton(
                    onPressed: () async {
                      _registerUser(context, _nameController.text, _emailController.text);
                    },
                    color: Colors.blueGrey,
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}