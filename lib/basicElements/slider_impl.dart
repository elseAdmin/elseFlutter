import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class SliderImpl extends StatefulWidget{
  final Function(double) callback;
  final double selectedValue;
  SliderImpl(this.callback,this.selectedValue);
  @override
  createState() => SliderImplState();

}
class SliderImplState extends State<SliderImpl>{
  double selectedValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedValue=widget.selectedValue;
  }
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
      activeColor: Constants.navBarButton,
      inactiveColor: Colors.blue,
      label: selectedValue.toString(),
    );
  }

}