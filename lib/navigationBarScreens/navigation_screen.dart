import 'package:else_app_two/basicElements/horizontal_list.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:else_app_two/basicElements/bottom_nav_bar.dart';

class SecondPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Second Page"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Back"),
              onPressed: (){
                new DatabaseManager().addUser();
              Navigator.pop(context);
            },
            ),
            Text("press the button to go to home page"),
            Text("we are on second page")
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(context),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}