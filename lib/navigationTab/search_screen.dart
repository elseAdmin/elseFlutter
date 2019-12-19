import 'dart:collection';

import 'package:else_app_two/models/shop_model.dart';
import 'package:else_app_two/navigationTab/vendor_search.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget{
  final HashMap<String, Set<ShopModel>> _indexShopMap;
  SearchScreen(this._indexShopMap);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: (){
          showSearch(context: context, delegate: VendorSearch());
        },
        child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Search for category or brand',
          ),
        ),
      ),
    );
  }

}