import 'package:else_app_two/Models/base_model.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<BaseModel> events;

  HorizontalList(List<BaseModel> events) : this.events = events;

  //write a builder over this widget which takes in item list etc and prepares a widget

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Card(
                child: Container(
                    child: Image(image: NetworkImage(events[index].url))),
              ),
            );
          }),
    );
  }
}
