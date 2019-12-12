import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/feedback/new_feedback.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/models/user_feedback_crud_model.dart';
import 'package:else_app_two/models/user_feedback_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'FeedbackStatus.dart';


class MyFeedbackPage extends StatefulWidget {
  @override
  _MyFeedbackPage createState() => _MyFeedbackPage();
}

class _MyFeedbackPage extends State<MyFeedbackPage> {

  UserFeedBackCrudModel userFeedBackCrudModel;
  List<UserFeedBack> _userFeedbackList = [];

//  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  List<String> updatedDate = [];

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    final BaseAuth _auth = AuthProvider.of(context).auth;
    final String userId = await _auth.currentUser();
    String path = 'users/$userId/feedbacks';
    userFeedBackCrudModel = UserFeedBackCrudModel(new Api(path));
    List<UserFeedBack> userFeedBackList = await userFeedBackCrudModel.fetchUserFeedBackList();
    if(userFeedBackList.isNotEmpty){
      setState(() {
        _userFeedbackList = userFeedBackList;
      });
      print(userFeedBackList.toString());
    }
  }

  String getStatusString(int status){
    switch(Status.values[status]){
      case Status.IN_PROCESS : return 'INPROCESS';
      case Status.PENDING : return 'PENDING';
      case Status.INVALID : return 'INVALID';
      case Status.COMPLETED : return 'COMPLETED';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.textColor),
        backgroundColor: Constants.titleBarBackgroundColor,
        title: Text(
          "Feedbacks",
          style: TextStyle(
            color: Constants.titleBarTextColor,
            fontSize: 18,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => NewFeedBack(),
            ),
          );
        },
      ),
      body: Card(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("All FeedBacks"),
              paddingData(),
              Container(
                height: MediaQuery.of(context).size.height * 7 / 8,
                decoration: BoxDecoration(
                  color: Constants.mainBackgroundColor,
                  border: Border.all(
                    color: Colors.white70,
                    width: 1.0,
                  ),
                ),
                child: ListView.separated(
                  itemCount: _userFeedbackList.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Constants.mainBackgroundColor,
                  ),
                  itemBuilder: (BuildContext context, int index){
                    return Column(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            title: Text(
                              '${_userFeedbackList[index].subject}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(18.0),
                            isThreeLine: true,
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('FeedBack ID : ${_userFeedbackList[index].feedbackId}'),
//                                  paddingData(),
                                  Text('Status : ${getStatusString(_userFeedbackList[index].feedbackStatus)}'),
//                                  paddingData(),
                                  Text('Date'),
//                                  paddingData(),
                                  Text('Place : ${_userFeedbackList[index].universe}'),
                                ],
                              ),
                            ),
                            trailing: Icon(Icons.arrow_right),
                            onTap: () {
//                          handler.routeToProfileOptions(context, index);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paddingData(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
    );
  }
}
