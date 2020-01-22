import 'package:else_app_two/feedback/models/feedback_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/helper_methods.dart';
import 'package:flutter/material.dart';

class FeedBackPreview {
  final String feedbackId;
  final String universe;
  final FeedBack feedBack;
  bool _expanded;
  FeedBackPreview(
      this.feedbackId, this.universe, this.feedBack, this._expanded);

  bool get expanded => _expanded;

  set expanded(bool value) {
    _expanded = value;
  }

  String getFeedBackType(bool feedbackType) {
    if (feedbackType) return "POSITIVE";
    return "NEGATIVE";
  }

  bool getIsActive(int currentIndex, int index) {
    if (currentIndex <= index) {
      return true;
    } else {
      return false;
    }
  }

  buildExpansionPanel() {
    if (feedBack.imageUrls.length == 0) {
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(
              '${feedBack.subject}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 3,
                bottom: SizeConfig.blockSizeVertical * 1,
                top: SizeConfig.blockSizeVertical * 1),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                richTextData(
                    'Status', feedBack.feedbackStatus),
                richTextData('Updated On', DateTime.fromMillisecondsSinceEpoch(feedBack.updatedDate).day.toString()+" "+HelperMethods().getMonthNameForMonth(DateTime.fromMillisecondsSinceEpoch(feedBack.updatedDate).month.toString())),
                richTextData('Place', universe),
              ],
            ),
          );
        },
        body: Container(
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 3,
              right: SizeConfig.blockSizeHorizontal * 3,
              bottom: SizeConfig.blockSizeVertical * 1),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(feedBack.content),
            richTextData('FeedBack ID', feedBack.id),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                richTextData("Type", getFeedBackType(feedBack.typeOfFeedBack)),
                richTextData(
                    "Intensity", feedBack.feedbackIntensity.toString()),
              ],
            ),
          ],
        )),
        isExpanded: _expanded,
      );
    } else {
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(
              '${feedBack.subject}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding: EdgeInsets.all(15.0),
            isThreeLine: true,
            subtitle: Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, top: 8.0, right: 0.0, bottom: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  richTextData(
                      'Status', feedBack.feedbackStatus),
                  richTextData('Updated On', DateTime.fromMillisecondsSinceEpoch(feedBack.updatedDate).day.toString()+" "+HelperMethods().getMonthNameForMonth(DateTime.fromMillisecondsSinceEpoch(feedBack.updatedDate).month.toString())),
                  richTextData('Place', universe),
                ],
              ),
            ),
          );
        },
        body: Card(
          child: ListTile(
            contentPadding:
                EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 8.0),
            title: Container(
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: feedBack.imageUrls.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return Center(
                      child: Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Image(
                          image: NetworkImage('${feedBack.imageUrls[index]}'),
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 230.0,
                        ),
                      ),
                    );
                  }),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                paddingData(),
                paddingData(),
                paddingData(),
                paddingData(),
                Text(feedBack.content),
                paddingData(),
                paddingData(),
                richTextData('FeedBack ID', feedBack.id),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    richTextData(
                        "Type", getFeedBackType(feedBack.typeOfFeedBack)),
                    richTextData(
                        "Intensity", feedBack.feedbackIntensity.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
        isExpanded: _expanded,
      );
    }
  }

  Widget paddingData() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
    );
  }

  Widget richTextData(String heading, String data) {
    return RichText(
      text: TextSpan(
          text: '$heading : ',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(
              text: '$data',
              style: TextStyle(
                  color: Constants.textColor, fontWeight: FontWeight.w400),
            ),
          ]),
    );
  }
}
