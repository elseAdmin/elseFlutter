

import 'package:flutter/material.dart';

class BottomNavigationBarItemsList {
  List<BottomNavigationBarItem> itemList;
  List<BottomNavigationBarItem> getItems(){
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.home,color: Color.fromARGB(255, 0, 0, 0)),
          title: new Text('Home', style: TextStyle(
            color: Colors.blue,
          ))
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.navigation,color: Color.fromARGB(255, 0, 0, 0)),
          title: new Text('Navigate', style: TextStyle(
            color: Colors.blue,
          ))
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.local_parking,color: Color.fromARGB(255, 0, 0, 0)),
          title: new Text('Parking', style: TextStyle(
            color: Colors.blue,
          ))
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.notifications,color: Color.fromARGB(255, 0, 0, 0)),
          title: new Text('Notify', style: TextStyle(
            color: Colors.blue,
          ))
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.verified_user,color: Color.fromARGB(255, 0, 0, 0)),
          title: new Text('Profile', style: TextStyle(
            color: Colors.blue,
          ))
      )
    ];
  }
}