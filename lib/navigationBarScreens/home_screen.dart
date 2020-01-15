import 'package:else_app_two/feedback/new_feedback.dart';
import 'package:else_app_two/home/deals/deal_horizontal_list.dart';
import 'package:else_app_two/home/events/event_horizontal_list.dart';
import 'package:else_app_two/home/events/feedback_section.dart';
import 'package:else_app_two/home/request_section.dart';
import 'package:else_app_two/requests/request_screen.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return ListView(
      padding: const EdgeInsets.all(3),
      children: <Widget>[
        EventSection(),
        DealSection(),
        RequestSection(),
        FeedbackSection()
      ],
    );
  }
}
