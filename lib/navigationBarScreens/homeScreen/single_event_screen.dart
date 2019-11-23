import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class SingleEventScreen extends StatelessWidget {
  EventModel event;
  SingleEventScreen(EventModel event) {
    this.event = event;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: Constants.mainBackgroundColor,
        child: ListView(
          children: <Widget>[

            Container(
                child: Image(
                        fit: BoxFit.cover, image: NetworkImage(event.url))),

            Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                  Text(event.name, style: TextStyle(fontSize: 20))
                ]),


            Container(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text("About this event:",style: TextStyle(fontSize: 13,color: Constants.textColor),)
              ],)
            ),


          ],
        ));
  }
}

/* ;*/
