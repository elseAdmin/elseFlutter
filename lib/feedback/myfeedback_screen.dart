import 'dart:collection';

import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/feedback/feedback_preview.dart';
import 'package:else_app_two/feedback/new_feedback.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/models/feedback_crud_model.dart';
import 'package:else_app_two/models/feedback_model.dart';
import 'package:else_app_two/models/user_feedback_crud_model.dart';
import 'package:else_app_two/models/user_feedback_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyFeedbackPage extends StatefulWidget {
  @override
  _MyFeedbackPage createState() => _MyFeedbackPage();
}

class _MyFeedbackPage extends State<MyFeedbackPage> {

  UserFeedBackCrudModel userFeedBackCrudModel;
  List<UserFeedBack> _userFeedbackList = [];
  Map<String, FeedBackPreview> _feedBackPreviewMap = new HashMap();
  FeedbackCrudModel feedbackCrudModel;

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    final BaseAuth _auth = AuthProvider.of(context).auth;
    final String userId = await _auth.currentUser();
    String path = 'users/$userId/feedbacks';
    userFeedBackCrudModel = UserFeedBackCrudModel(new Api(path));
    List<UserFeedBack> userFeedBackList = await userFeedBackCrudModel.fetchUserFeedBackList();
    if(userFeedBackList.isNotEmpty){
      for(UserFeedBack userFeedBack in userFeedBackList){
        String path = userFeedBack.universe + '/feedback/allfeedbacks';
        feedbackCrudModel = new FeedbackCrudModel(new Api(path));
        FeedBack feedBack = await feedbackCrudModel.getFeedBackById(userFeedBack.feedbackId);
        if(feedBack != null){
          FeedBackPreview feedBackPreview = new FeedBackPreview
            (userFeedBack.feedbackId, userFeedBack.universe, feedBack, false);
          setState(() {
            _userFeedbackList = userFeedBackList;
            _feedBackPreviewMap[userFeedBack.feedbackId] = feedBackPreview;
          });
        }
      }
      print(userFeedBackList.toString());
    }
  }

  _onExpansion(int index, bool isExpanded){
//    print("Index::: "+index.toString());
    FeedBackPreview feedBackPreview = _feedBackPreviewMap[_userFeedbackList[index].feedbackId];
    feedBackPreview.expanded = !feedBackPreview.expanded;
    setState(() {
      _feedBackPreviewMap[_userFeedbackList[index].feedbackId] = feedBackPreview;
    });
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
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    "All feedback threads",
                ),
                Container(
                  margin: EdgeInsets.only(left: 0.0, top: 18.0, right: 0.0, bottom: 0.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index){
                      List<ExpansionPanel> myExpansionPanelList = [];
                      for(int i=0; i<_feedBackPreviewMap.length; ++i ){
                        myExpansionPanelList.add(_feedBackPreviewMap[_userFeedbackList[i].feedbackId].buildExpansionPanel());
                      }
                      return new ExpansionPanelList(
                        children: myExpansionPanelList,
                        expansionCallback: _onExpansion,
                      );
                    },
                  ),
                ),
              ],
            ),
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