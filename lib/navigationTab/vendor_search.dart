import 'dart:collection';

import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/vendor_list.dart';
import 'package:else_app_two/navigationTab/vendor_stream_id.dart';
import 'package:flutter/material.dart';

class VendorSearch extends SearchDelegate<ShopModel> {
  List<String> keys;
  HashMap<String, Set<ShopModel>> _indexShopMap;
  VendorStreamId _vendorStreamId;
  VendorSearch(this.keys, this._indexShopMap) {
    _vendorStreamId = VendorStreamId(this.keys);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<String>>(
      stream: _vendorStreamId.shopStream,
      builder: (context, AsyncSnapshot<UnmodifiableListView<String>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text("No data"),
          );
        }

        final results =
            snapshot.data.where((a) => a.toLowerCase().contains(query));

        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
                    title: Text(a),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      query = a;
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VendorList(_indexShopMap, query),
                        ),
                      );
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<UnmodifiableListView<String>>(
      stream: _vendorStreamId.shopStream,
      builder: (context, AsyncSnapshot<UnmodifiableListView<String>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text("No data"),
          );
        }

        final results =
            snapshot.data.where((a) => a.toLowerCase().contains(query));

        return ListView(
          children: results
              .map<ListTile>((a) => ListTile(
                    title: Text(a),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      query = a;
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VendorList(_indexShopMap, query),
                        ),
                      );
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}
