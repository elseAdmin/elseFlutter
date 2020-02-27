import 'package:else_app_two/basicElements/LoadingDialog.dart';
import 'package:else_app_two/basicElements/LoginDialog.dart';
import 'package:else_app_two/basicElements/camera_impl.dart';
import 'package:else_app_two/basicElements/slider_impl.dart';
import 'package:else_app_two/feedback/FeedbackStatus.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/firebaseUtil/storage_manager.dart';
import 'package:else_app_two/feedback/models/feedback_crud_model.dart';
import 'package:else_app_two/feedback/models/feedback_model.dart';
import 'package:else_app_two/auth/models/user_crud_model.dart';
import 'package:else_app_two/feedback/models/user_feedback_crud_model.dart';
import 'package:else_app_two/feedback/models/user_feedback_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';

class NewFeedBack extends StatefulWidget {
  @override
  _NewFeedBack createState() => _NewFeedBack();
}

class _NewFeedBack extends State<NewFeedBack> {
  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool _typeOfFeedBack = true;
  double _intensityValue = 0.0;
  List imageUrls = [];
  static String pathFeedbackCollection =
      StartupData.dbreference + '/feedback/allfeedbacks';
  final FeedbackCrudModel feedbackCrudModel =
      FeedbackCrudModel(new Api(pathFeedbackCollection));

  UserFeedBackCrudModel userFeedBackCrudModel;
  final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));
  final StorageManager _storageManager =
      StorageManager(StartupData.dbreference + '/feedback/');

  @override
  initState() {
    if (StartupData.user != null) {
      isLoggedIn = true;
    }
    super.initState();
  }

  setUserRating(double rating) {
    _intensityValue = rating;
  }

  onImageSelectedFromCamera(file) async {
//    print('Uploading File :: ' + file.toString());
    int id = new DateTime.now().millisecondsSinceEpoch;
    String path = StartupData.dbreference + '/feedback/$id';
    _storageManager.addFilePath(path);
    String uploadUrl = await _storageManager.uploadImageUrl(file);
    setState(() {
      imageUrls.add(uploadUrl);
      print('Values in image url list ' + imageUrls.toString());
    });
  }

  removeImage(int index) async {
    String path = imageUrls[index];
//    _storageManager.addFilePath(path);
//    await _storageManager.removeImageUrl();
    setState(() {
      imageUrls.remove(path);
      print(imageUrls);
    });
  }

  _addFeedBack(String subject, bool typeOfFeedBack, double feedbackIntensity,
      String content, List images) async {
    List<String> imageUrls = images.cast<String>();
    FeedBack feedBack = new FeedBack(
        subject,
        typeOfFeedBack,
        feedbackIntensity,
        content,
        imageUrls,
        StatusString.getString(Status.PENDING),
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch);

    String feedBackUrl = await feedbackCrudModel.addFeedBack(feedBack);
    await DatabaseManager().incrementFeedbackCount();
    if (feedBackUrl != null) {
      UserFeedBack userFeedBack = new UserFeedBack(feedBackUrl);
      await userFeedBackCrudModel.addUserFeedBack(userFeedBack);
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return getModal();
          });
    }
  }

  void _popContext(BuildContext context) {
    Navigator.pop(context);
  }

  Widget getModal() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white70,
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Feedback Registered",
              textAlign: TextAlign.center,
            ),
            subtitle: Text("You kow how much we love to hear from you, thanks for writing to us."),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
          ),
          FlatButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              _popContext(context);
            },
            child: Text(
              'Ok',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.navBarButton),
        backgroundColor: Colors.white,
        title: Text(
          "Feedback",
          style: TextStyle(
            color: Constants.navBarButton,
            fontSize: Constants.appbarTitleSize,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Constants.navBarButton,
        child: Icon(Icons.send),
        onPressed: _submit,
      ),
      body: Form(
        key: _formKey,
        child: ListView(children: <Widget>[
          Card(
              elevation: 2,
              margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1.5),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 3,
                          left: SizeConfig.blockSizeHorizontal * 3),
                      child: TextFormField(
                        maxLength: 150,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          labelStyle:
                              TextStyle(fontSize: Constants.editTextSize),
                        ),
                        controller: _subjectController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a subject';
                          }
                          return null;
                        },
                      )),
                  Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 3),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Emotion",
                            style: TextStyle(fontSize: Constants.editTextSize),
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Radio(
                            activeColor: Constants.navBarButton,
                            value: true,
                            groupValue: _typeOfFeedBack,
                            onChanged: (bool newValue) {
                              setState(() {
                                _typeOfFeedBack = newValue;
                              });
                            }),
                        Text("Positive"),
                      ]),
                      Row(
                        children: <Widget>[
                          Radio(
                              activeColor: Constants.navBarButton,
                              value: false,
                              groupValue: _typeOfFeedBack,
                              onChanged: (bool newValue) {
                                setState(() {
                                  _typeOfFeedBack = newValue;
                                });
                              }),
                          Text("Negative")
                        ],
                      )
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 3),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Intensity",
                            style: TextStyle(fontSize: Constants.editTextSize)),
                      )),
                  SliderImpl(this.setUserRating, 0),
                ],
              )),
          Card(
            elevation: 2,
            margin: EdgeInsets.only(
                bottom: SizeConfig.blockSizeHorizontal * 1.5,
                left: SizeConfig.blockSizeHorizontal * 1.5,
                right: SizeConfig.blockSizeHorizontal * 1.5),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(
                      right: SizeConfig.blockSizeHorizontal * 3,
                      left: SizeConfig.blockSizeHorizontal * 3,
                      bottom: SizeConfig.blockSizeHorizontal * 3,
                    ),
                    child: TextFormField(
                      maxLength: 500,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        labelStyle: TextStyle(fontSize: Constants.editTextSize),
                      ),
                      controller: _contentController,
                      keyboardType: TextInputType.multiline
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 3,
                            bottom: SizeConfig.blockSizeVertical),
                        child: Text(
                          "Upload Image",
                          style: TextStyle(fontSize: Constants.editTextSize),
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 3,
                            right: SizeConfig.blockSizeHorizontal * 3,
                            bottom: SizeConfig.blockSizeVertical),
                        child: CameraImpl(onImageSelectedFromCamera))
                  ],
                ),
              ],
            ),
          ),
          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return imageCard(index);
              }),
        ]),
      ),
    );
  }

  _submit() async {
    if (isLoggedIn) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => LoadingDialog());
      String userId = StartupData.user.id;
      String path = 'users/$userId/feedbacks';
      userFeedBackCrudModel = UserFeedBackCrudModel(new Api(path));
      if (_formKey.currentState.validate()) {
        await _addFeedBack(_subjectController.text, _typeOfFeedBack,
            _intensityValue, _contentController.text, imageUrls);
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => LoginDialog(onSignIn));
    }
  }

  onSignIn() {
    isLoggedIn = true;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OauthManager(onSignedIn: _submit),
      ),
    );
  }

  Widget imageCard(int index) {
    return Stack(
      children: <Widget>[
        Card(
          child: Image(
            fit: BoxFit.fill,
            image: NetworkImage('${imageUrls[index]}'),
          ),
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape
                  .circle, // You can use like this way or like the below line
              color: Colors.white,
              border: Border.all(
                color: Constants.textColor,
                width: 1.0,
              ),
            ),
            child: Center(
              child: IconButton(
                iconSize: 18.0,
                color: Colors.black,
                icon: Icon(Icons.close),
                onPressed: () {
                  removeImage(index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
/*
  Widget paddingData(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
    );
  }*/
}
