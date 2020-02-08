import 'package:else_app_two/basicElements/LoginDialog.dart';
import 'package:else_app_two/basicElements/StarRating.dart';
import 'package:else_app_two/basicElements/slider_impl.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReviewRatingSection extends StatefulWidget {
  final ShopModel shop;
  ReviewRatingSection(this.shop);
  @override
  createState() => ReviewRatingSectionState();
}

class ReviewRatingSectionState extends State<ReviewRatingSection> {
  double userRating = -1;
  String userReview;

  double previousRating = 0;
  bool ratingSubmitButtonVisibility = true;

  String previousReview='';
  bool reviewSubmitButtonVisibility = true;

  _submitUserReviewRating() {
    if (StartupData.user != null && StartupData.user.id != null) {
      if (userRating != -1) {
        DatabaseManager().saveUserRatingForStore(widget.shop.uid, userRating);
      }
      if (userReview != null) {
        DatabaseManager().saveUserReviewForStore(widget.shop.uid, userReview);
      }
      Fluttertoast.showToast(
          msg: "Thanks for the effort",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 14.0);
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => LoginDialog(onSignIn));
    }
  }

  onSignIn() {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OauthManager(onSignedIn: _submitUserReviewRating),
      ),
    );
  }

  setUserRating(double rating) {
    userRating = rating;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseManager()
        .getReviewRatingForStore(widget.shop.uid, onReviewRatingFound);
  }

  onReviewRatingFound(double rating, String review) {
    if (rating != null) {
      setState(() {
        previousRating = rating;
        ratingSubmitButtonVisibility = false;
      });
    }
    if (review != null) {
      setState(() {
        previousReview = review;
        reviewSubmitButtonVisibility = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String storeName = widget.shop.name;
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text('Rate',
                style: TextStyle(
                    fontSize: 20,
                    color: Constants.textColor,
                    fontWeight: FontWeight.w600)),
            subtitle: Column(children: <Widget>[
              StarRating(previousRating, this.setUserRating),
              Visibility(
                  visible: ratingSubmitButtonVisibility,
                  child: GestureDetector(
                    child: Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical,
                            bottom: SizeConfig.blockSizeVertical * 2),
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 16),
                        )),
                    onTap: () => _submitUserReviewRating(),
                  ))
            ]),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Review',
                style: TextStyle(
                    fontSize: 20,
                    color: Constants.textColor,
                    fontWeight: FontWeight.w600)),
            subtitle: Column(
              children: <Widget>[
                Visibility(
                  visible: !reviewSubmitButtonVisibility,
                  child: Text(previousReview),
                ),
                Visibility(
                    visible: reviewSubmitButtonVisibility,
                    child: Column(children: <Widget>[
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        onChanged: (text) {
                          userReview = text;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a review for $storeName'),
                      ),
                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical,
                                bottom: SizeConfig.blockSizeVertical * 2),
                            child: Text(
                              "Submit",
                              style: TextStyle(fontSize: 16),
                            )),
                        onTap: () => _submitUserReviewRating(),
                      )
                    ]))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
