import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/vendor_details.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class VendorList extends StatefulWidget {
  final HashMap<String, Set<ShopModel>> _indexShopMap;
  final String listKey;
  VendorList(this._indexShopMap, this.listKey);

  _VendorList createState() => _VendorList();
}

class _VendorList extends State<VendorList> {
  List<ShopModel> _shopModelList = new List();

  List<ShopModel> getShopModelList(String key) {
    if (key.isEmpty) {
      Set<ShopModel> shopModelSet = new Set();
      for (Set<ShopModel> setShop in widget._indexShopMap.values) {
        shopModelSet.addAll(setShop);
      }
      return shopModelSet.toList();
    } else {
      if (widget._indexShopMap[key] == null) {
        return List();
      }
      return widget._indexShopMap[key].toList();
    }
  }

  @override
  void initState() {
    super.initState();
    List<ShopModel> shopModelList = getShopModelList(widget.listKey);
    setState(() {
      _shopModelList = shopModelList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.titleBarBackgroundColor,
        iconTheme: IconThemeData(
          color: Constants.navBarButton, //change your color here
        ),
        title: Text(
          widget.listKey.toUpperCase(),
          style: TextStyle(
            color: Constants.navBarButton,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
        child: GridView.builder(
            itemCount: _shopModelList.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 2,
                child: GestureDetector(
                  onTap: () {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VendorDetails(_shopModelList[index]),
                      ),
                    );
                  },
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      CachedNetworkImage(
                        fit: BoxFit.fill,
                        colorBlendMode: BlendMode.luminosity,
                        imageUrl: _shopModelList[index].imageUrl,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
