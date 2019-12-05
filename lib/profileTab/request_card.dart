import 'package:else_app_two/service/api.dart';
import 'package:else_app_two/service/user_crud_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequestCard extends StatefulWidget{

  @override
  _RequestCard createState() => _RequestCard();
}

class _RequestCard extends State<RequestCard>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));


  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white70,
              width: 1.0,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Name'
                  ),
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Phone'
                  ),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter valid Phone Number';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
                TextFormField(
                  maxLines: 6,
                  decoration: const InputDecoration(
                      labelText: 'Message'
                  ),
                  controller: _messageController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
                FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      print("Inside Data");
                    }
                  },
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '** Name and Phone Number is required to contact you back for request',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 10.0,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '** Message section mention the problem for which you need help',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 10.0,
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