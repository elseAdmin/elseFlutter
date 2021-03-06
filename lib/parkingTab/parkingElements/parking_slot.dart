import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class ParkingSlot extends StatefulWidget{

  final int colorValue;
  final String text;
  final int factor, angleStruct;
  final bool isUser;
  ParkingSlot(this.colorValue, this.text, this.factor, this.angleStruct, this.isUser);

  @override
  _ParkingSlot createState() => _ParkingSlot();
}

class _ParkingSlot extends State<ParkingSlot>{
  int _color = 0;
  double _height = 40.0;
  double _width = 24.0;
  String _text = '';
  int _turns = 0;
  double _fontSize = 8.0;

  getColor(int colorValue, bool isUser){
    if(isUser){
      return Colors.green;
    }
    if(colorValue == 0){
      return Constants.vacantSpace;
    }
    return Constants.parkedVehicle;
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _color = widget.colorValue;
      _height = _height;
      _width = _width;
      _text = widget.text;
      _turns = widget.angleStruct;
      _fontSize = _fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: _turns,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        height: _height * widget.factor,
        width: _width * widget.factor,
        child: Center(
          child: Text(
            _text,
            style: TextStyle(
              fontSize: _fontSize * widget.factor,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: getColor(widget.colorValue, widget.isUser),
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
    );
  }

}