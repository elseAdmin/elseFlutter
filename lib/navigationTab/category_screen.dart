import 'package:else_app_two/navigationTab/category_grid.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white70,
          width: 1.0,
        ),
      ),
      child: ListView(
//        scrollDirection: Axis.vertical,
//        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Text("All Categories"),
          ),
          CategoryGrid(),
        ],
      ),
    );
  }
}