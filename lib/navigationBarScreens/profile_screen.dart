
import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/profileTab/general_section.dart';
import 'package:else_app_two/profileTab/login_logout_section.dart';
import 'package:else_app_two/profileTab/my_section.dart';
import 'package:else_app_two/profileTab/user_profile_info.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget{
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {

  bool isUserLogged = false;

  void _signOut(){
    setState(() {
      isUserLogged = false;
    });
  }

  void _signIn(){
    setState(() {
      isUserLogged = true;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if(StartupData.user != null && StartupData.user.id!=null){
      setState(() {
        isUserLogged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        UserProfileInfo(isUserLogged),
        DividerPadding(isUserLogged),
        MySection(isUserLogged),
        DividerPadding(isUserLogged),
        GeneralSection(),
        LoginLogoutSection(isUserLogged, _signOut, _signIn),
      ],
    );

  }
}

class DividerPadding extends StatelessWidget{
  final bool isUserLoggedIn;
  DividerPadding(this.isUserLoggedIn);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
      ),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: isUserLoggedIn,
    );
  }
}

