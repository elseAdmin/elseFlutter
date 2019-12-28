import 'dart:collection';

import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/category_grid.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget{

  final HashMap<String, Set<ShopModel>> _indexShopMap;
  CategoryScreen(this._indexShopMap);

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
        children: <Widget>[
          Center(
            child: Text("All Categories"),
          ),
          CategoryGrid(_indexShopMap),
          paddingData()
        ],
      ),
    );
  }

  Widget paddingData(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
    );
  }
}