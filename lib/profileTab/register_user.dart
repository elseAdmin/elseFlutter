import 'package:else_app_two/auth/models/user_model.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/auth/models/user_crud_model.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  final User user;
  final String phoneNumber;
  final VoidCallback onSignedIn;
  RegisterUser(this.user, this.phoneNumber, this.onSignedIn);

  @override
  _RegisterUser createState() => _RegisterUser();
}

class _RegisterUser extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  void _registerUser(BuildContext context, String name, String email) {
    User user = new User(widget.user.id, widget.phoneNumber, name, email);

    final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));
    userProvider.addUserById(user).then((value){
      StartupData.user = user;
      Navigator.pop(context);
      widget.onSignedIn();
    });
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
          child: Form(
            key: _formKey,
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
                    if (value.length == 0) {
                      return 'Name';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Id'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.send,
                  validator: (value) {
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(value))
                      return 'Enter Valid Email';
                    else
                      return null;
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width / 2,
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _registerUser(context, _nameController.text,
                              _emailController.text);
                        }
                      },
                      color: Colors.blueGrey,
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
