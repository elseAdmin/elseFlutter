import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/basicElements/slider_impl.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/navigationTab/UserDealSection.dart';
import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/vendor_deals.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VendorDetails extends StatelessWidget {
  final ShopModel _shopModel;
  VendorDetails(this._shopModel);
  double userRating = -1;
  String userReview;

  _submitUserRating() {
    if (userRating != -1) {
      DatabaseManager().saveUserRatingForStore(_shopModel.name, userRating);
      Fluttertoast.showToast(
          msg: "Thanks for the effort",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  _submitUserReview() {
    if (userReview != null) {
      DatabaseManager().saveUserReviewForStore(_shopModel.name, userReview);
      Fluttertoast.showToast(
          msg: "Thanks for the effort",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  setUserRating(double rating) {
    userRating = rating;
  }

  @override
  Widget build(BuildContext context) {
    String storeName = _shopModel.name;
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Constants.mainBackgroundColor,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: SizeConfig.blockSizeVertical * 25,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Opacity(
                      opacity: 0.6,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: _shopModel.imageUrl,
                      ))),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    child: ListTile(
                      title: Text('${_shopModel.name}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w900)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          paddingData(),
                          paddingData(),
                          Text('${_shopModel.about}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Constants.textColor,
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Details',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          richTextData("Shop No", _shopModel.shopNo),
                          richTextData("Floor", _shopModel.floor.toString()),
                          richTextData(
                              "Timing",
                              _shopModel.openTime +
                                  ' to ' +
                                  _shopModel.closeTime),
                          richTextData("Contant Info", _shopModel.contactInfo),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Offers',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600)),
                      subtitle: Text('Yet to start offer on this',
                          style: TextStyle(
                              fontSize: 12,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  UserDealSection(_shopModel.uid),
                  VendorDealSection(_shopModel.uid),
                  Card(
                    child: ListTile(
                      title: Text('Rate this store',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600)),
                      subtitle: Column(children: <Widget>[
                        SliderImpl(this.setUserRating),
                        GestureDetector(
                          child: Container(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical,
                                  bottom: SizeConfig.blockSizeVertical * 2),
                              child: Text(
                                "Submit",
                                style: TextStyle(fontSize: 16),
                              )),
                          onTap: () => _submitUserRating(),
                        )
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
                      subtitle: Column(children: <Widget>[
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
                          onTap: () => _submitUserReview(),
                        )
                      ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*3),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paddingData() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
    );
  }

  Widget richTextData(String heading, String data) {
    return RichText(
      text: TextSpan(
          text: '$heading : ',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(
              text: '$data',
              style: TextStyle(
                  color: Constants.textColor, fontWeight: FontWeight.w400),
            ),
          ]),
    );
  }
}
