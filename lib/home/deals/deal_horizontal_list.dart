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
    deals = DatabaseManager.deals;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    if(deals!=null){
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
            height: MediaQuery.of(context).size.height * 0.22,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: deals.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Card(
                        child: GestureDetector(
                          onTap:  () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DealsDetails(deals[index], deals[index].tnc.toList(), deals[index].details.toList())));
                          },
                          child: Stack(
                            fit: StackFit.passthrough,
                            children: <Widget>[
                              Opacity(
                                opacity: 0.4,
                                child:CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: deals[index].blurUrl,
//                                    height: MediaQuery.of(context).size.height * 0.15,
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.all(0.0),
                                color: Colors.transparent,
                                child: Center(
                                  child:  Text(deals[index].shortDetails,
                                      style: TextStyle(
                                          color: Constants.mainBackgroundColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
                }))
      ],
    );
  }else{
      return Text("No deals as such");
    }
  }

}
