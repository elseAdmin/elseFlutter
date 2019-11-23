
import 'package:else_app_two/profileTab/profile_screen_route.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {

  final List<String> entries = <String>['Help', 'About', 'Share', 'Rate', 'Logout'];

  ProfileScreenRoute handler = new ProfileScreenRoute();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Center(child: Text('${entries[index]}')),
          onTap: () {
              handler.routeToProfileOptions(context, index);
          },
        );
      },
    );
  }
}

