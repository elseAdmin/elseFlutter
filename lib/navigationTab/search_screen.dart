import 'dart:collection';

import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/vendor_search.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final HashMap<String, Set<ShopModel>> _indexShopMap;
  SearchScreen(this._indexShopMap);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: const InputDecoration(
          labelText: 'Search for category or brand',
        ),
        readOnly: true,
        onTap: () {
          showSearch(
              context: context,
              delegate:
                  VendorSearch(_indexShopMap.keys.toList(), _indexShopMap));
        },
      )
    ;
  }
}
