import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class MyEventListPage extends StatelessWidget {
  List<EventModel> events;
  MyEventListPage(List<EventModel> events) {
    this.events = events;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.titleBarBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Events",
              style: TextStyle(
                color: Constants.titleBarTextColor,
                fontSize: 18,
              )),
          centerTitle: true,
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  child: Container(
                      child: Image(image: NetworkImage(events[index].url))),
                ),
              );
            }));
  }
}
