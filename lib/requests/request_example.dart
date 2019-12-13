import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class RequestExample extends StatefulWidget{

  @override
  _RequestExample createState() => _RequestExample();
}

class _RequestExample extends State<RequestExample>{

  List _list = [];
  FireBaseApi _fireBaseApi = FireBaseApi("requestsStaticData/requestsExamples");

  @override
  Future didChangeDependencies() async {
    super.didChangeDependencies();
    var results = await _fireBaseApi.getDataSnapshot();
    setState(() {
      _list = results.value.toList();
      print("List fetched "+_list.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white70,
            width: 1.0,
          ),
        ),
        child: ListTile(
          title: Text('What you can request',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Constants.test,
            ),
          ),
          subtitle: ListView.builder(
            scrollDirection: Axis.vertical,
//            itemExtent: 50.0,
            itemCount: _list.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                  '•  ${_list[index]}',
                  style: TextStyle(
                    color: Constants.test,
                  )
              );
            },
          ),
        ),
      ),
    );
  }

}