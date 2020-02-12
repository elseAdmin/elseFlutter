import 'dart:typed_data';

import 'package:else_app_two/parkingTab/parking_ui_screen.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';

class QrScanner extends StatefulWidget{
  final VoidCallback outParking;
  QrScanner(this.outParking);

  @override
  createState() => QrScannerState();
}

class QrScannerState extends State<QrScanner>{
  String barcodeString = '';
  Uint8List bytes = Uint8List(200);

  void _outParking(){
    widget.outParking();
  }

  @override
  Widget build(BuildContext context) {
    if (!Constants.hasScannedForParking) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Scan the barcode at the entry of the premise'),
              Container(height: 20),
              GestureDetector(onTap: () => _scan(),
                  child: Text("Scan", style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),)),
            ],
          ),
        ),
      );
    }else{
      //barcode is now scanned
      return ParkingUIScreen(null, _outParking);
    }
  }
  Future _scan() async {
    Constants.parkingEligibleUser=true;
    Constants.hasScannedForParking = true;
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcodeString = barcode);
    } catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcodeString = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcodeString = 'Unknown error: $e');
      }
    }
  }
}

/*
Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('you parking location will now be automatically traced.'),
            ],
          ),
        ),
      )
 */