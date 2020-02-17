import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/deals/deal_list_page.dart';
import 'package:else_app_two/home/deals/deals_details.dart';
import 'package:else_app_two/home/deals/models/deals_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
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
    DatabaseManager.dealsFound = dealsFound;
    deals = DatabaseManager.deals;
  }

  dealsFound(List<DealModel> foundDeals) {
    setState(() {
      deals = foundDeals;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    if (deals != null) {
      return Container(
          color: Constants.titleBarBackgroundColor,
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1,
            bottom: SizeConfig.blockSizeVertical * 1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DealListPage(deals)));
                    },
                    child: Text(
                      "Deals",
                      style: TextStyle(
                        fontSize: Constants.homePageHeadingsFontSize,
                      ),
                    ),
                  )),
              Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: deals.length,
                      itemBuilder: (context, index) {
                        return Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: Card(
                              elevation: 2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DealsDetails(
                                                  deals[index],
                                                  deals[index].tnc.toList(),
                                                  deals[index]
                                                      .details
                                                      .toList())));
                                },
                                child: Stack(
                                  fit: StackFit.passthrough,
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      colorBlendMode: BlendMode.luminosity,
                                      fit: BoxFit.cover,
                                      imageUrl: deals[index].blurUrl,
//                                    height: MediaQuery.of(context).size.height * 0.15,
                                    ),
                                    Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: SizeConfig
                                                    .blockSizeVertical,
                                                left: SizeConfig
                                                        .blockSizeHorizontal *
                                                    2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(deals[index].shortDetails,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15)),
                                              ],
                                            )))
                                  ],
                                ),
                              ),
                            ));
                      }))
            ],
          ));
    } else {
      return Text("No deals as such");
    }
  }
}
