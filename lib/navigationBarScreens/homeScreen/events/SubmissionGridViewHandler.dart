import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/WinnerSectionView.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/submission_grid_view.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class SubmissionGridViewHandler {
  EventModel event;
  SubmissionGridViewHandler(EventModel model){
    this.event=model;
  }
  Widget renderSuitableSubmissionGridView() {
    if (this.event.endDate.isBefore(DateTime.now())) {
        return WinnerSectionView(event.uid);
    }
    else{
      return SubmissionGridView(this.event.uid);
    }
  }
}