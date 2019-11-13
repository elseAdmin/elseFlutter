import 'package:else_app_two/Models/base_model.dart';
import 'package:else_app_two/Models/deals_model.dart';
import 'package:else_app_two/Models/events_model.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DealList extends StatefulWidget {
  @override
  _DealListState createState() => new _DealListState();
}

class _DealListState extends State<DealList>{
  List<DealModel> dealList = new List();
  final DatabaseManager manager = DatabaseManager();
  @override
  void initState() {
    super.initState();
    manager.getDealsDBRef().onChildAdded.listen(_newDealAdded);
  }
  void _newDealAdded(Event e){
    DealModel newDeal = new DealModel(e.snapshot);
    if(newDeal.status=='active'){
      setState(() {
        dealList.add(newDeal);
      });
    } else if (newDeal.status == 'inactive') {
      if (dealList.contains(newDeal)) {
        setState(() {
          dealList.remove(newDeal);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dealList.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Card(
                child: Container(
                    child: Image(image: NetworkImage(dealList[index].url))),
              ),
            );
          }),
    );
  }

}
