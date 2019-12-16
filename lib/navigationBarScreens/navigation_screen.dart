import 'package:else_app_two/navigationTab/category_screen.dart';
import 'package:else_app_two/navigationTab/search_screen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget{
  @override
  _NavigationScreen createState() => _NavigationScreen();
}

class _NavigationScreen extends State<NavigationScreen>{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SearchScreen(),
          CategoryScreen(),
        ],
      ),
    );
  }

}