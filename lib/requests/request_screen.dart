import 'package:else_app_two/auth/models/user_crud_model.dart';
import 'package:else_app_two/basicElements/LoadingDialog.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'models/request_crud_model.dart';
import 'models/request_model.dart';

class RequestsPage extends StatefulWidget {
  @override
  RequestPageState createState() => RequestPageState();
}

class RequestPageState extends State<RequestsPage> {
  final logger = Logger();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  TextEditingController _userIdController = TextEditingController();
  static String pathRequestCollection =
      StartupData.dbreference + '/requests/allRequests';
  final RequestCrudModel requestCrudModel =
      RequestCrudModel(new Api(pathRequestCollection));
  final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));
  @override
  void initState() {
    super.initState();
    if (StartupData.user != null) {
      _nameController.text = StartupData.user.name;
      _phoneController.text = StartupData.user.phoneNumber;
      _userIdController.text = StartupData.user.id;
    }
  }

  void _popContext(BuildContext context) {
    Navigator.pop(context);
  }

  void _addRequest(
      BuildContext context, String name, String phone, String message) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LoadingDialog());
    Request request = new Request(phone, name, message, _userIdController.text);
    String requestFuture = await requestCrudModel.addRequest(request);
    if (requestFuture != null) {
      await DatabaseManager().saveUserRequest(requestFuture);
      //closes the loading dialog box
      Navigator.of(context, rootNavigator: true).pop();

      showModalBottomSheet(
          isDismissible: false,
          context: context,
          builder: (context) {
            return getModal();
          });
    }
  }

  Widget getModal() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
              child: Text(
                "Request placed",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              )),
          Container(
              padding: EdgeInsets.only(
                  right: SizeConfig.blockSizeVertical,
                  left: SizeConfig.blockSizeVertical),
              child: Text(
                  "We have received your request, you will be served shortly. Our team might contact you on the given Phone number to serve you in the best manner.  ")),
          FlatButton(
            padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
            onPressed: () {
              Navigator.pop(context);
              _popContext(context);
            },
            child: Text(
              'Ok',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Constants.navBarButton, //change your color here
        ),
        title: Text(
          "Request",
          style: TextStyle(
            color: Constants.navBarButton,
            fontSize: 26,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Constants.navBarButton,
        child: Icon(Icons.send),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            // If the form is valid, display a Snackbar.
            print("Inside Data");

            _addRequest(context, _nameController.text, _phoneController.text,
                _messageController.text);
          }
        },
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1.5),
            elevation: 2,
            child: Container(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(fontSize: 19),
                          icon: Icon(Icons.account_circle)),
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(fontSize: 19),
                          icon: Icon(Icons.phone)),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty || value.length != 10) {
                          return 'Please enter valid Phone Number';
                        }

                        return null;
                      },
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: SizeConfig.blockSizeVertical),
                      child: Text(
                        'We need your Name and Phone Number to serve your request',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      maxLength: 500,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          labelText: 'Request message',
                          hintStyle: TextStyle(fontSize: 12),
                          hintText:
                              "Please write in brief about, how can we serve you?",
                          labelStyle: TextStyle(fontSize: 19)),
                      controller: _messageController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
              margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1.5),
              elevation: 2,
              child: Container(
                padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical,
                    bottom: SizeConfig.blockSizeVertical),
                child: ListTile(
                  title: Text(
                    'You could request about things like',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: ListView.builder(
                    padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: Constants.requestExampleList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text('•  ${Constants.requestExampleList[index]}',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ));
                    },
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
