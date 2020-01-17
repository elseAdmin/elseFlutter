import 'package:flutter/material.dart';

class Stairs extends StatefulWidget{
  final int factor;
  Stairs(this.factor);

  @override
  _Stairs createState() => _Stairs();
}

class _Stairs extends State<Stairs>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.0 * widget.factor,
      height: 25.0 * widget.factor,
      decoration: BoxDecoration(
        color: Colors.brown[100],
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Center(
        child: Text('STAIRS',style: TextStyle(fontSize: 5.0 * widget.factor),),
      ),
    );
  }

}