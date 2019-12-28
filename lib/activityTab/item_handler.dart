import 'package:else_app_two/activityTab/acitvityViews/deal_activity.dart';
import 'package:else_app_two/activityTab/acitvityViews/event_activity.dart';
import 'package:else_app_two/activityTab/acitvityViews/feedback_activity.dart';
import 'package:else_app_two/activityTab/acitvityViews/parking_activity.dart';
import 'package:else_app_two/activityTab/acitvityViews/request_activity.dart';

class ActivityTypeHandler {
  getAppropriateViewForActivity(String type, var item) {
    if (type.compareTo('UserRequestModal') == 0) {
      return RequestActivity(item);
    } else if (type.compareTo('ParkingModel') == 0) {
      return ParkingActivity(item);
    } else if (type.compareTo('UserDealModel') == 0) {
      return DealActivity(item);
    } else if (type.compareTo('UserEventSubmissionModel') == 0) {
      return EventActivity(item);
    } else if (type.compareTo('UserFeedBack') == 0) {
      return FeedbackActivity(item);
    }
  }
}
