import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/models/user_model.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/models/user_crud_model.dart';
import 'package:flutter/material.dart';

class UserProfileInfo extends StatefulWidget{
  final bool isUserLogged;
  UserProfileInfo(this.isUserLogged);

  @override
  _UserProfileInfo createState() => _UserProfileInfo();

}

class _UserProfileInfo extends State<UserProfileInfo>{

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));



  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final BaseAuth _auth = AuthProvider.of(context).auth;
    final String userId = await _auth.currentUser();
    User user = await userProvider.getUserById(userId);
    if(user != null && userId.isNotEmpty){
      setState(() {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = '+91-'+user.phoneNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          contentPadding: const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
          title: Text(
            _nameController.text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
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

  Widget userInfoChild(){

  }

}