import 'dart:io';

import 'package:else_app_two/basicElements/camera_impl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Parking extends StatefulWidget{
  @override
  ParkingState createState() => ParkingState();
}

class ParkingState  extends State<Parking> {
  @override
  Widget build(BuildContext context) {
    return Text("parking");
  }

}