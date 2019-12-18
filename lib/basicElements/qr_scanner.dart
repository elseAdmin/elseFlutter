import 'dart:typed_data';

import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class QrScanner extends StatefulWidget{
  @override
  createState() => QrScannerState();
}

class QrScannerState extends State<QrScanner>{
  String barcodeString = '';
  Uint8List bytes = Uint8List(200);
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
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('you parking location will now be automatically traced.'),
            ],
          ),
        ),
      );
    }
  }
  Future _scan() async {
    String barcode = await scanner.scan();

    Constants.parkingEligibleUser=true;
    Constants.hasScannedForParking = true;
    setState(() => this.barcodeString = barcode);
  }
}