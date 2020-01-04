import 'package:flutter/material.dart';

class Elevator extends StatefulWidget{

  @override
  _Elevator createState() => _Elevator();
}

class _Elevator extends State<Elevator>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 23.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Center(
        child: Text('LIFT',style: TextStyle(fontSize: 5.0),),
      ),
    );
  }

}