import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/deals/deals_details.dart';
import 'package:else_app_two/home/deals/models/deals_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class VendorDealSection extends StatefulWidget {
  final String shopUid;
  VendorDealSection(this.shopUid);
  @override
  State<StatefulWidget> createState() => VendorDealSectionState();
}

class VendorDealSectionState extends State<VendorDealSection> {
  List<DealModel> shopDeals = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseManager().getDealsForShop(widget.shopUid, dealsFound);
  }

  dealsFound(List<DealModel> deals) {
    setState(() {
      shopDeals = deals;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (shopDeals.length != 0) {
      return Card(
          child: ListTile(
            title: Text(
              'Deals',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
            ),
              subtitle: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: shopDeals.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Constants.mainBackgroundColor,
                    child: GestureDetector(
                      onTap: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DealsDetails(
                                shopDeals[index],
                                shopDeals[index].tnc.toList(),
                                shopDeals[index].details.toList()),
                          ),
                        );
                      },
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: <Widget>[
                          Opacity(
                            opacity: 0.5,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: shopDeals[index].url,
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(0.0),
                            color: Colors.transparent,
                            child: Center(
                              child: Text(shopDeals[index].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12)),
                            ),
                          ),
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
