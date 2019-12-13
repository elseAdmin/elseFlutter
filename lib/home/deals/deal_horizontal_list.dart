import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/deals/deal_list_page.dart';
import 'package:else_app_two/home/deals/deals_details.dart';
import 'package:else_app_two/models/deals_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DealSection extends StatefulWidget {
  @override
  _DealSectionState createState() => new _DealSectionState();
}

class _DealSectionState extends State<DealSection> {
  List<DealModel> deals = new List();
  final DatabaseManager manager = DatabaseManager();

  @override
  void initState() {
    super.initState();
    manager.getDealsDBRef().onChildAdded.listen(_newDealAdded);
  }

  void _newDealAdded(Event e) {
    DealModel newDeal = new DealModel(e.snapshot);
    if (newDeal.status == 'active') {
      setState(() {
        deals.add(newDeal);
      });
    } else if (newDeal.status == 'inactive') {
      if (deals.contains(newDeal)) {
        setState(() {
          deals.remove(newDeal);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 1,
                left: SizeConfig.blockSizeHorizontal * 2),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DealListPage(deals)));
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Deals",
                      style: TextStyle(
                        fontSize: Constants.homePageHeadingsFontSize,
                      ),
                    ),
                    Divider(
                        endIndent: SizeConfig.blockSizeHorizontal * 60,
                        color: Colors.black87,
                        height: SizeConfig.blockSizeVertical)
                  ]),
            )),
        Container(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 1,
                right: SizeConfig.blockSizeHorizontal * 1),
            height: MediaQuery.of(context).size.height * 0.20,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: deals.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Card(
                        child: GestureDetector(
                          onTap:  () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DealsDetails(deals[index], deals[index].tnc.toList())));
                          },
                          child: Column(
                            children: <Widget>[
                              Card(
//                                opacity: 0.8,
                                  child:CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: deals[index].blurUrl,
                                    height: MediaQuery.of(context).size.height * 0.15,
                                  )),
                              Text(deals[index].name,
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      backgroundColor: Colors.white,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ));
                }))
      ],
    );
  }
}
