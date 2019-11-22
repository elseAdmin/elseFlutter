
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/deals_model.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/deal_list_page.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DealList extends StatefulWidget {
  @override
  _DealListState createState() => new _DealListState();
}

class _DealListState extends State<DealList> {
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
    // TODO: implement build
    return Column(children: <Widget>[
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => DealListPage(deals)));
        },
        child: new Text(
          "Deals",
          style: TextStyle(
            fontSize: Constants.homePageHeadingsFontSize,
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: deals.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Card(
                  child: Container(
                      child: Image(image: NetworkImage(deals[index].url))),
                ),
              );
            }),
      )
    ]);
  }
}
