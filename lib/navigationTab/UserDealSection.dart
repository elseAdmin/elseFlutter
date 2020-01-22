import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/beaconAds/models/ad_beacon_model.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDealSection extends StatefulWidget {
  final String shopUid;
  UserDealSection(this.shopUid);
  @override
  createState() => UserDealSectionState();
}

class UserDealSectionState extends State<UserDealSection> {
  List<AdBeacon> userDeals = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseManager().getUserSpecificDealsForShop(widget.shopUid, dealsFound);
  }

  dealsFound(List<AdBeacon> deals) {
    setState(() {
      userDeals = deals;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (userDeals.length != 0) {
      return Card(
          child: ListTile(
              title: Text(
                'Your Deals',
                style: TextStyle(fontSize: 17),
              ),
              subtitle: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: userDeals.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Constants.mainBackgroundColor,
                            child: GestureDetector(
                              onTap: () {
                                return;
                              },
                              child: Stack(
                                fit: StackFit.passthrough,
                                children: <Widget>[
                                  Opacity(
                                    opacity: 0.5,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: userDeals[index].imageUrl,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                  ])));
    } else {
      return Container();
    }
  }
}
