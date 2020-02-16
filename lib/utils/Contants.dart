import 'dart:collection';

import 'package:flutter/material.dart';

class Constants {
   static Color mainBackgroundColor = Colors.grey[100];
   static Color titleBarBackgroundColor =Colors.white;
   static Color dividerColor = Colors.grey[500];

   static Color navBarButton =Color.fromRGBO(7, 51, 159, 1.0);
   static Color titleBarTextColor = Colors.white;
   static Color horizontalListBackgroundColor = Colors.grey[0];

   static Color textColor = Colors.grey[800];

   static Color test = Colors.grey[600];


   static double homePageHeadingsFontSize=18;


   static String pendingStatusMessage = "Your submssion is pending approval";

   static String universe = "UnityOne Rohini";

   //below have to go into mysql, how and who will set these back to false logically?
   static bool parkingEligibleUser = false;
   static bool hasScannedForParking = false;
   static bool inRangeForParking = false;
   static Color parkedVehicle = Colors.deepOrange[200];
   static Color vacantSpace = Colors.white70;

   static int parkingLevel=-1;
   static int section=-1;

   static String universeDisplayName = "Else";

   static Map beaconTimeStampMap = new HashMap<String, int>();
}