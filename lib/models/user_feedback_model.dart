import 'package:else_app_two/utils/Contants.dart';

class UserFeedBack{
  String universe;
  String url;
  DateTime timestamp;

  UserFeedBack(this.url);

  UserFeedBack.fromMap(Map snapshot) :
        timestamp = DateTime.fromMillisecondsSinceEpoch(snapshot['timestamp']) ?? '',
        url = snapshot['feedbackurl'] ?? '',
        universe = snapshot['universe'] ?? '';

  toJson(){
    return{
      "timestamp":DateTime.now().millisecondsSinceEpoch,
      "feedbackurl":url,
      "universe":Constants.universe
    };
  }


}