import 'dart:collection';

import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/category_screen.dart';
import 'package:else_app_two/navigationTab/search_screen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget{
  @override
  _NavigationScreen createState() => _NavigationScreen();
}

class _NavigationScreen extends State<NavigationScreen>{

  List<ShopModel> shops = new List();

  HashMap<String, Set<ShopModel>> _indexShopMap = new HashMap();
  FireBaseApi _fireBaseApi = FireBaseApi("shopStaticData");

  @override
  Future didChangeDependencies() async{
    super.didChangeDependencies();
    HashMap<String, Set<ShopModel>> indexShopMap = new HashMap();
    var results = await _fireBaseApi.getDataSnapshot();
    List shopsKey = results.value.keys.toList();
    Map<dynamic, dynamic> values=results.value;

    for(String shop in shopsKey){
      Set<ShopModel> shopModelList = new Set();
      ShopModel shopModel = ShopModel.fromMap(values[shop]);
      shopModelList.add(shopModel);
      indexShopMap[shop] = shopModelList;
      for(String category in shopModel.category){
        Set<ShopModel> shopModelsCategory = indexShopMap[category];
        if(shopModelsCategory == null){
          shopModelsCategory = new Set();
        }
        shopModelsCategory.add(shopModel);
        indexShopMap[category] = shopModelsCategory;
      }
    }
    setState(() {
      _indexShopMap = indexShopMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SearchScreen(_indexShopMap),
          CategoryScreen(_indexShopMap),
          paddingData()
        ],
      ),
    );
  }

  Widget paddingData(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
    );
  }

}