import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/auth/models/user_model.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/auth/models/user_crud_model.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';

class UserProfileInfo extends StatefulWidget {
  final bool isUserLogged;
  UserProfileInfo(this.isUserLogged);

  @override
  _UserProfileInfo createState() => _UserProfileInfo();
}

class _UserProfileInfo extends State<UserProfileInfo> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (StartupData.user != null) {
      _nameController.text = StartupData.user.name;
      _emailController.text = StartupData.user.email;
      _phoneController.text = StartupData.user.phoneNumber;
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  setValues() {
    if (StartupData.user != null) {
      _nameController.text = StartupData.user.name;
      _emailController.text = StartupData.user.email;
      _phoneController.text = StartupData.user.phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    setValues();
    return Visibility(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white70,
            width: 1.0,
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          title: Text(
            _nameController.text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_emailController.text),
                Text(_phoneController.text)
              ],
            ),
          ),
          trailing: Icon(Icons.edit),
        ),
      ),
      maintainSize: false,
      maintainAnimation: true,
      maintainState: true,
      visible: widget.isUserLogged,
    );
  }

  Widget userInfoChild() {}
}
