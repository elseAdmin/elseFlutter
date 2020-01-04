import 'package:flutter/material.dart';

class Constants {
   static Color mainBackgroundColor = Colors.grey[100];
   static Color titleBarBackgroundColor =Colors.grey[100];
   static Color titleBarTextColor = Colors.grey[800];
   static Color horizontalListBackgroundColor = Colors.grey[0];

   static Color textColor = Colors.grey[800];

   static Color test = Colors.grey[600];


   static double homePageHeadingsFontSize=18;


   static String pendingStatusMessage = "Your submssion is pending approval";

   static String universe = "unityOneRohini";

   //below have to go into mysql, how and who will set these back to false logically?
   static bool parkingEligibleUser = false;
   static bool hasScannedForParking = false;
   static int parkingLevel=-1;
}