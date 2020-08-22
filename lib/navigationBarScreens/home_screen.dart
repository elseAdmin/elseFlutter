import 'dart:collection';

import 'package:else_app_two/basicElements/BleOffScreen.dart';
import 'package:else_app_two/feedback/new_feedback.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/deals/deal_horizontal_list.dart';
import 'package:else_app_two/home/events/event_horizontal_list.dart';
import 'package:else_app_two/home/events/feedback_section.dart';
import 'package:else_app_two/home/request_section.dart';
import 'package:else_app_two/navigationBarScreens/navigation_screen.dart';
import 'package:else_app_two/navigationTab/category_grid.dart';
import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/vendor_search.dart';
import 'package:else_app_two/navigationTab/vendor_staggered_view.dart';
import 'package:else_app_two/requests/request_screen.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final logger = Logger();
  bool refresh = false;
  Future<Null> _handleRefresh() async {
    DatabaseManager().refreshEventsAndDeals(onRefresh);
    return null;
  }

  HashMap<String, Set<ShopModel>> _indexShopMap = new HashMap();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseManager.indexShopFound = shopDataFound;
    _indexShopMap = DatabaseManager.indexShopMap;
  }

  shopDataFound(HashMap<String, Set<ShopModel>> indexShopMap) {
    setState(() {
      _indexShopMap = indexShopMap;
    });
  }

  onRefresh() {
    setState(() {
      refresh = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Constants.navBarButton,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => NavigationScreen(),
          ));
        },
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: VendorStaggeredView(_indexShopMap),
        /*ListView(
          shrinkWrap: true,
          children: <Widget>[
            TextField(
              style: TextStyle(fontSize: 25.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
              ),
            ),
            GridView.count(
                primary: true,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: <Widget>[
                  RequestSection(),
                  FeedbackSection(),
                  Container(
                      margin: EdgeInsets.all(SizeConfig.blockSizeVertical * 2),
                      child: GestureDetector(
                        child: Container(
                          decoration: myDecor(),
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.blockSizeHorizontal),
//                            color: Constants.titleBarBackgroundColor,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.poll,
                                      size: 35, color: Constants.navBarButton),
                                  Text(
                                    'Polls',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Constants.navBarButton),
                                  )
                                ])),
                        onTap: () {},
                      )),
                ]),
            //
            //
            EventSection(),
            Container(
              height: SizeConfig.blockSizeVertical,
              color: Constants.mainBackgroundColor,
            ),
            DealSection(),
            Container(
              height: SizeConfig.blockSizeVertical,
              color: Constants.mainBackgroundColor,
            ),
            Container(
              padding:
              EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
    child: Text(
              "Categories",
              style: TextStyle(
                fontSize: Constants.homePageHeadingsFontSize,
              ),
            )),*//*
//            CategoryGrid(_indexShopMap),
            VendorStaggeredView(_indexShopMap),
          ],
        ),*/
      ),
    );
  }

  BoxDecoration myDecor() {
    return BoxDecoration(
      color: Constants.titleBarBackgroundColor,
      border: Border.all(
        color: Constants.navBarButton,
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
    );
  }

}
