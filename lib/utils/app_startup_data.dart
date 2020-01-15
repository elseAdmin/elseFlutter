import 'package:else_app_two/auth/models/user_model.dart';

class StartupData {
  //below code makes this class singleton
  factory StartupData() {
    return _singleton;
  }
  StartupData._internal();
  static final StartupData _singleton = StartupData._internal();

  static User user;
  static String dbreference = 'unityOneRohini';
  static String userReference = 'users';
  static String uuid = '00000000-0000-0000-0000-000000000000';

  static String userid='suhailMacIOSsimulator';
  List<String> universes = List();
}



