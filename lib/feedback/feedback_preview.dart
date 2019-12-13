import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/models/feedback_crud_model.dart';
import 'package:else_app_two/models/feedback_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class FeedBackPreview extends StatefulWidget{

  String feedbackId;
  String universe;
  FeedBackPreview(this.feedbackId, this.universe);

  @override
  _FeedBackPreview createState() => _FeedBackPreview();
}

class _FeedBackPreview extends State<FeedBackPreview>{
  double value = 0.0;
  FeedbackCrudModel feedbackCrudModel;
  int _index = 0;
  FeedBack _feedBack;
  List imageUrls = [];

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    print('FeedbackId :: '+widget.feedbackId);
    String path = widget.universe + '/feedback/allfeedbacks';
    feedbackCrudModel = new FeedbackCrudModel(new Api(path));
    FeedBack feedBack = await feedbackCrudModel.getFeedBackById(widget.feedbackId);
    if(feedBack != null){
      setState(() {
        _feedBack = feedBack;
        _index = _feedBack.feedbackStatus;
        imageUrls = _feedBack.imageUrls;
      });
      print(feedBack.toString());
    }
  }

  String getFeedBackType(bool feedbackType){
    if(feedbackType)
      return "POSITIVE";
    return "NEGATIVE";
  }

  bool getIsActive(int currentIndex, int index){
    if(currentIndex<=index){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.textColor),
        backgroundColor: Constants.titleBarBackgroundColor,
        title: Text(
          "Feedbacks Details",
          style: TextStyle(
            color: Constants.titleBarTextColor,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white70,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${_feedBack.subject}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                Stepper(
                  steps: [
                    Step(
                      title: Text("Pending"),
                      content: Text("FeedBack is just submitted and still not verified"),
                      isActive: getIsActive(0, _index),
                    ),
                    Step(
                      title: Text("Valid"),
                      content: Text("FeedBack is verified. We'll start working on this"),
                      isActive: getIsActive(1, _index),
                    ),
                    Step(
                      title: Text("InValid"),
                      content: Text("Invalid feedback found."),
                      isActive: getIsActive(2, _index),
                    ),
                    Step(
                      title: Text("InProgess"),
                      content: Text("Started working on your feedback. You will observe the change soon"),
                      isActive: getIsActive(3, _index),
                    ),
                    Step(
                      title: Text("Completed"),
                      content: Text("Thanks for your valuable feedback task is completed"),
                      isActive: getIsActive(4, _index),
                    ),
                  ],
                  currentStep: _index,
                  onStepTapped: (index) {
                    setState(() {
                      _index = index;
                    });
                  },
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                      Container(),
                ),
                paddingData(),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    width: MediaQuery.of(context).size.width ,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index){
                          return Center(
                            child: Card(
                              child: Image(
                                image: NetworkImage('${imageUrls[index]}'),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
                paddingData(),
                paddingData(),
                paddingData(),
                Text("FeedBack ID: ${_feedBack.id}"),
                Text(_feedBack.content),
                /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Type: ${getFeedBackType(_feedBack.typeOfFeedBack)}"),
                  Text("Intensity: ${_feedBack.feedbackIntensity}"),
                ],
              ),
              paddingData(),
              Text('Created Date: ${_feedBack.createdDate}'),
              Text('Updated Date: ${_feedBack.updatedDate}'),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget paddingData(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
    );
  }
}