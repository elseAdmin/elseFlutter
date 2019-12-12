import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class FeedBackPreview extends StatefulWidget{

  @override
  _FeedBackPreview createState() => _FeedBackPreview();
}

class _FeedBackPreview extends State<FeedBackPreview>{
  double value = 0.0;
  var _index = 0;

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
      body: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("FeedBack ID "),
              paddingData(),
              Text(
                "HEADING",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              Stepper(
                steps: [
                  Step(
                    title: Text("First"),
                    content: Text("This is our first example."),
                    isActive: getIsActive(0, _index),
                  ),
                  Step(
                    title: Text("Second"),
                    content: Text("This is our second example."),
                    isActive: getIsActive(1, _index),
                  ),
                  Step(
                    title: Text("Third"),
                    content: Text("This is our third example."),
                    isActive: getIsActive(2, _index),
                  ),
                  Step(
                    title: Text("Forth"),
                    content: Text("This is our forth example."),
                    isActive: getIsActive(3, _index),
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
            ],
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