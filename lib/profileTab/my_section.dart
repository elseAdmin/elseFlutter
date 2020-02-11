import 'package:else_app_two/profileTab/profile_my_section_route.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class MySection extends StatelessWidget {
  final bool isUserLogged;

  MySection(this.isUserLogged);

  final List<String> listData = <String>['My Events', 'My Feedback'];
  final listIcons = <IconData>[Icons.event, Icons.feedback];
  final ProfileMySectionScreenRoute handler = new ProfileMySectionScreenRoute();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
        color: Colors.white,
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(
            color: Constants.dividerColor,
            indent: SizeConfig.blockSizeHorizontal * 5,
            endIndent: SizeConfig.blockSizeHorizontal * 5,
          ),
          shrinkWrap: true,
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
      maintainSize: false,
      maintainAnimation: true,
      maintainState: true,
      visible: isUserLogged,
    );
  }
}
