import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class VendorDetails extends StatelessWidget{
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
              expandedHeight: SizeConfig.blockSizeVertical * 25,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: _shopModel.imageUrl,
                  )),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  paddingData(),
                  Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      title: Text('${_shopModel.name}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w900
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          paddingData(),
                          paddingData(),
                          Text(
                              '${_shopModel.about}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Constants.textColor,
                                  fontWeight: FontWeight.w300
                              )
                          ),
                          paddingData(),
                        ],
                      ),
                    ),
                  ),
                  paddingData(),
                  Card(
                    child: ListTile(
                      title: Text('Details',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          richTextData("Shop No", _shopModel.shopNo),
                          richTextData("Floor", _shopModel.floor.toString()),
                          richTextData("Timing", _shopModel.openTime + ' to ' + _shopModel.closeTime),
                          richTextData("Contant Info", _shopModel.contactInfo),

                        ],
                      ),
                    ),
                  ),
                  paddingData(),
                  Card(
                    child: ListTile(
                      title: Text('Offers',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600
                          )),
                      subtitle: Text('Yet to start offer on this',
                          style: TextStyle(
                              fontSize: 12,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w400
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paddingData(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
    );
  }

  Widget richTextData(String heading, String data){
    return RichText(
      text: TextSpan(
          text: '$heading : ',
          style: TextStyle(
              color: Constants.textColor,
              fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(text: '$data',
              style: TextStyle(
                  color: Constants.textColor,
                  fontWeight: FontWeight.w400
              ),
            ),
          ]
      ),
    );
  }
}