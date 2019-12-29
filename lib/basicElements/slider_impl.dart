import 'package:flutter/material.dart';

class SliderImpl extends StatefulWidget{
  final Function(double) callback;
  SliderImpl(this.callback);
  @override
  createState() => SliderImplState();

}
class SliderImplState extends State<SliderImpl>{
  double selectedValue=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Slider(
      value: selectedValue,
      min: 0.0,
      max: 5.0,
      divisions: 10,
      onChanged: (double newValue) {
        setState(() {
          selectedValue = newValue;
        });
          widget.callback(selectedValue);
      },
      activeColor: Colors.blue,
      inactiveColor: Colors.black45,
      label: selectedValue.toString(),
    );
  }

}