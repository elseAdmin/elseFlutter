import 'package:else_app_two/models/deals_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class DealListPage extends StatelessWidget {
  List<DealModel> deals;
  DealListPage(List<DealModel> deals){
    this.deals=deals;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.titleBarBackgroundColor,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Deals",
              style: TextStyle(
                color: Constants.titleBarTextColor,
                fontSize: 18,
              )),
          centerTitle: true,
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: deals.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  child: Container(
                      child: Image(image: NetworkImage(deals[index].url))),
                ),
              );
            }));
  }
}