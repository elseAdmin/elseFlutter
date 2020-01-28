import 'package:else_app_two/feedback/feedback_preview.dart';
import 'package:else_app_two/feedback/new_feedback.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/feedback/models/feedback_crud_model.dart';
import 'package:else_app_two/feedback/models/user_feedback_crud_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyFeedbackPage extends StatefulWidget {
  @override
  createState() => MyFeedbackPageState();
}

class MyFeedbackPageState extends State<MyFeedbackPage> {
  UserFeedBackCrudModel userFeedBackCrudModel;
  List<FeedBackPreview> _feedBackPreviewMap = List();
  FeedbackCrudModel feedbackCrudModel;

  @override
  void initState() {
    super.initState();
    _feedBackPreviewMap = DatabaseManager.myFeedbacks;
  }

  _onExpansion(int index, bool isExpanded) {
    FeedBackPreview feedBackPreview = _feedBackPreviewMap[index];
    feedBackPreview.expanded = !feedBackPreview.expanded;
    setState(() {
      _feedBackPreviewMap[index] = feedBackPreview;
    });
  }

  Future<Null> _handleRefresh() async {
    DatabaseManager().getFeedbacksByUser(true).then((newFeedbacks){
      setState(() {
        _feedBackPreviewMap = newFeedbacks;
      });
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (_feedBackPreviewMap != null) {
      return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Scaffold(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewFeedBack(),
                    ),
                  );
                },
              ),
              body: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  List<ExpansionPanel> myExpansionPanelList = [];
                  for (int i = 0; i < _feedBackPreviewMap.length; ++i) {
                    myExpansionPanelList
                        .add(_feedBackPreviewMap[i].buildExpansionPanel());
                  }
                  return new ExpansionPanelList(
                    children: myExpansionPanelList,
                    expansionCallback: _onExpansion,
                  );
                },
              )));
    } else {
      return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Scaffold(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewFeedBack(),
                    ),
                  );
                },
              ),
              body: Center(
                child: Text('You have not given any feedback yet'),
              )));
    }
  }
}
