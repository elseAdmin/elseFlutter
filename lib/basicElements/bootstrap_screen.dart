import 'dart:async';
import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/auth/models/user_crud_model.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/home/home_page.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';

class Bootstrap extends StatefulWidget {
  @override
  createState() => BootstrapState();
}

class BootstrapState extends State<Bootstrap> {
  @override
  void initState() {
    super.initState();

    FireBaseApi _fireBaseApi = FireBaseApi("shopStaticData");

    DatabaseManager().getAllShops(true,_fireBaseApi);
    DatabaseManager().getAllActivityOfUser(true);
    DatabaseManager().getAllActiveEvents(true);
    DatabaseManager().getAllActiveDeals(true);

    var _duration = new Duration(seconds: 4);
    Timer(_duration, navigationPage);
  }

  @override
  didChangeDependencies() {
    SizeConfig().init(context);
    _userRelatedStuff();

    super.didChangeDependencies();
  }

  void navigationPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => MyHomePage(title: 'Else')));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Else",
              style: TextStyle(fontSize: 40),
            ),
            //Container(padding:EdgeInsets.only(top:SizeConfig.blockSizeVertical*7),child:Text("Loading....")),
            Container(
              padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 3,
                  left: SizeConfig.blockSizeHorizontal * 10,
                  right: SizeConfig.blockSizeHorizontal * 10),
              child: LinearProgressIndicator(),
            )
          ],
        ),
      ),
    ));
  }

  void _userRelatedStuff() {
    final BaseAuth _auth = AuthProvider.of(context).auth;
    _auth.currentUser().then((userId) {
      UserCrudModel('users', new Api('users')).getUserById(userId).then((user) {
        print(user);
        if (user != null && userId.isNotEmpty) {
          StartupData.user = user;
        }
      });
    });
  }
}
