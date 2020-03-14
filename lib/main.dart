import 'package:else_app_two/bootstrap_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'auth/auth.dart';
import 'auth/auth_provider.dart';

void main() {
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Else',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
        auth: Auth(),
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home: Bootstrap()));
  }
}
