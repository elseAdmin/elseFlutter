

import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarItemsList {
  List<BottomNavigationBarItem> itemList;
  List<BottomNavigationBarItem> getItems(){
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.home,color: Constants.navBarButton),
          title: new Text('Home', style: TextStyle(
            color:Constants.navBarButton,
          ))
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.explore,color:Constants.navBarButton),
          title: new Text('Explore', style: TextStyle(
            color: Constants.navBarButton,
          ))
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.local_parking,color:Constants.navBarButton),
          title: new Text('Parking', style: TextStyle(
            color: Constants.navBarButton,
          ))
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.event_note,color: Constants.navBarButton),
          title: new Text('Activity', style: TextStyle(
            color: Constants.navBarButton,
          ))
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle,color:Constants.navBarButton),
          title: new Text('Profile', style: TextStyle(
            color: Constants.navBarButton,
          ))
      )
    ];
  }
}