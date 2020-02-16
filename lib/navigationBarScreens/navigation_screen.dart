import 'dart:collection';

import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/navigationTab/category_grid.dart';
import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/vendor_search.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> {
  List<ShopModel> shops = new List();
  HashMap<String, Set<ShopModel>> _indexShopMap = new HashMap();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _indexShopMap = DatabaseManager.indexShopMap;
  }

  Future<Null> _handleRefresh() async {
    HashMap<String, Set<ShopModel>> indexShopMap = await DatabaseManager()
        .getAllShops(true, FireBaseApi("shopStaticData"));

    setState(() {
      _indexShopMap = indexShopMap;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Scaffold(
          backgroundColor: Constants.mainBackgroundColor,
          floatingActionButton: FloatingActionButton(
            elevation: 10,
            backgroundColor: Constants.navBarButton,
            child: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate:
                      VendorSearch(_indexShopMap.keys.toList(), _indexShopMap));
            },
          ),
          body: Container(
              child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //SearchScreen(_indexShopMap),
                  CategoryGrid(_indexShopMap),
                ],
              )
            ],
          )),
        ));
  }
}
/*
ListView(
          children: <Widget> [Column(
            children: <Widget>[
              SearchScreen(_indexShopMap),
              CategoryScreen(_indexShopMap),
            ],
          )],
        )*/
