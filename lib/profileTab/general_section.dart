import 'package:else_app_two/profileTab/profile_screen_route.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class GeneralSection extends StatelessWidget{

  final List<String> listData = <String>['Help', 'About', 'Request', 'Share', 'Rate'];
  final listIcons = <IconData>[Icons.help, Icons.info, Icons.message, Icons.share, Icons.rate_review];
  ProfileScreenRoute handler = new ProfileScreenRoute();

  @override
  Widget build(BuildContext context) {
    return  Container(
        color:Colors.white,
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(
            color: Constants.dividerColor,
            indent: SizeConfig.blockSizeHorizontal * 5,
            endIndent: SizeConfig.blockSizeHorizontal * 5,
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
    );
  }

}