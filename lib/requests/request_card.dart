import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/request_model.dart';
import 'package:else_app_two/models/user_model.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/models/request_crud_model.dart';
import 'package:else_app_two/models/user_crud_model.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class RequestCard extends StatefulWidget{

  @override
  _RequestCard createState() => _RequestCard();
}

class _RequestCard extends State<RequestCard>{
  final logger = Logger();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  TextEditingController _userIdController = TextEditingController();
  static String pathRequestCollection = StartupData.dbreference+'/requests/allRequests';
  final RequestCrudModel requestCrudModel = RequestCrudModel(new Api(pathRequestCollection));
  final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    final BaseAuth _auth = AuthProvider.of(context).auth;
    final String userId = await _auth.currentUser();
    User user = await userProvider.getUserById(userId);
    if(user != null && userId.isNotEmpty){
      setState(() {
        _nameController.text = user.name;
        _phoneController.text = '+91-'+user.phoneNumber;
        _userIdController.text = userId;
      });
    }
  }

  void _popContext(BuildContext context){
    Navigator.pop(context);
  }

  void _addRequest(BuildContext context, String name, String phone, String message) async{
    Request request = new Request(phone, name, message, _userIdController.text);
    String requestFuture = await requestCrudModel.addRequest(request);
    if(requestFuture !=null){
      await DatabaseManager().saveUserRequest(requestFuture);
      print('Request added successfully ' + requestFuture.toString());
      showModalBottomSheet(context: context, builder: (context){
        return getModal();
      });
    }
  }

  Widget getModal(){
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white70,
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Request Saved Successfully", textAlign: TextAlign.center,),
            subtitle: Text("Our team has recieved the request and we'll try to connect you shortly......"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
          ),
          FlatButton(
            color: Colors.white,
            onPressed: (){
              Navigator.pop(context);
              _popContext(context);
            },
            child: Text('Ok', style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20.0),),
          )
        ],
      ),
    );
  }


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

                      _addRequest(context, _nameController.text, _phoneController.text, _messageController.text);
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