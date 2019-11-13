import 'package:flutter/cupertino.dart';
import 'package:else_app_two/navigationBarScreens/navigation_screen.dart';
import 'package:flutter/material.dart';
//use this widget to add bottom navigation bar to any screen
class BottomNavBar extends StatelessWidget{
  int _cIndex = 0;
  BuildContext context;
  BottomNavBar(BuildContext context){
    this.context = context;
  }
  void _handleBottomNavigationTab(index) {
    switch(index){
      case 0:
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondPage()));
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _cIndex,
      type: BottomNavigationBarType.fixed ,
      //backgroundColor: Colors.blueGrey,
      items: [
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
      ],
      onTap: (index){
        _handleBottomNavigationTab(index);
      },
    );
  }

}