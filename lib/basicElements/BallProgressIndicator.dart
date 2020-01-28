import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class BallProgressIndicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Loading(
          indicator: BallPulseIndicator(), size: 60.0, color: Colors.blue),
    );
  }

}