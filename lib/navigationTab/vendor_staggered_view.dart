import 'dart:collection';

import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/vendor_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class VendorStaggeredView extends StatefulWidget {
  final HashMap<String, Set<ShopModel>> _indexShopMap;

  VendorStaggeredView(this._indexShopMap);
  _VendorStaggeredView createState() => _VendorStaggeredView();
}

class _VendorStaggeredView extends State<VendorStaggeredView> {

  List<ShopModel> _shopModelList = new List();

  List<ShopModel> getShopModelList() {
    Set<ShopModel> shopModelSet = new Set();
    for (Set<ShopModel> setShop in widget._indexShopMap.values) {
      shopModelSet.addAll(setShop);
    }
    return shopModelSet.toList();
  }

  @override
  void initState() {
    super.initState();
    List<ShopModel> shopModelList = getShopModelList();
    setState(() {
      _shopModelList = shopModelList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
//          shrinkWrap: true,
          primary: true,
//          physics: NeverScrollableScrollPhysics(),
          itemCount: _shopModelList.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
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
                child: GridTile(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage, image: _shopModelList[index].imageUrl,fit: BoxFit.fill,
                    ),
                  ),
                  footer: Card(
                    child: ListTile(
                      title: Text(_shopModelList[index].name),
                      subtitle: Text("Number of people in store"),
                    ),
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (index) {
            return new StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
          }),
    );
  }

}