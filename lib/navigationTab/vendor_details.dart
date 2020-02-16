import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/navigationTab/ReviewRatingSection.dart';
import 'package:else_app_two/navigationTab/UserDealSection.dart';
import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/navigationTab/vendor_deals.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class VendorDetails extends StatelessWidget {
  final ShopModel _shopModel;
  VendorDetails(this._shopModel);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Constants.mainBackgroundColor,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Constants.titleBarBackgroundColor,
              expandedHeight: SizeConfig.blockSizeVertical * 25,
              floating: false,
              pinned: true,
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(
                    Icons.close,
                    size: 27,
                    color: Constants.navBarButton,
                  ),
                  onPressed: () => Navigator.of(context).pop(context),
                ),
              ],
              leading: Container(),
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: CachedNetworkImage(
                    colorBlendMode: BlendMode.luminosity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: _shopModel.imageUrl,
                  )),
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
                              fontWeight: FontWeight.w500)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                              fontWeight: FontWeight.w500)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          paddingData(),
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
                  ReviewRatingSection(_shopModel),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: SizeConfig.blockSizeVertical * 3),
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
