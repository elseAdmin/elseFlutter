import 'package:flutter/material.dart';

class MySection extends StatelessWidget{
  final bool isUserLogged;

  MySection(this.isUserLogged);

  final List<String> listData = <String>['My Events', 'My Feedback', 'My Request'];
  final listIcons = <IconData>[Icons.event, Icons.feedback, Icons.message];

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white70,
            width: 1.0,
          ),
        ),
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          padding: const EdgeInsets.all(3),
          shrinkWrap: true,
          itemCount: listData.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('${listData[index]}'),
              leading: Icon(listIcons[index]),
            );
          },
        ),
      ),
      maintainSize: false,
      maintainAnimation: true,
      maintainState: true,
      visible: isUserLogged,
    );
  }

}