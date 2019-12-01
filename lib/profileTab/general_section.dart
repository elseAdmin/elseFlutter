import 'package:else_app_two/profileTab/profile_screen_route.dart';
import 'package:flutter/material.dart';

class GeneralSection extends StatelessWidget{

  final List<String> listData = <String>['Help', 'About', 'Share', 'Rate'];
  final listIcons = <IconData>[Icons.help, Icons.info, Icons.share, Icons.rate_review];
  ProfileScreenRoute handler = new ProfileScreenRoute();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
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
          itemCount: listData.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('${listData[index]}'),
              leading: Icon(listIcons[index]),
              onTap: () {
                handler.routeToProfileOptions(context, index);
              },
            );
          },
        ),
      ),
    );
  }

}