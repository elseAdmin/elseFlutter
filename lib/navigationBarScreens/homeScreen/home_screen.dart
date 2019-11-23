import 'package:else_app_two/basicElements/deal_horizontal_list.dart';
import 'package:else_app_two/basicElements/event_horizontal_list.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      padding: const EdgeInsets.all(3),
      children: <Widget>[
        EventSection(),
        DealSection()
      ],
    );
  }
}
