import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/models/deals_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class DealsDetails extends StatelessWidget{
  final DealModel deals;
  final List tnc;
  bool buttonPressed = false;

  DealsDetails(this.deals, this.tnc);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Constants.mainBackgroundColor,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: SizeConfig.blockSizeVertical * 20,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: deals.url,
                  )),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  paddingData(),
                  Card(
                    child: ListTile(
                      title: Text('${deals.name}',
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
                              '${deals.details}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Constants.textColor,
                                  fontWeight: FontWeight.w300
                              )
                          ),
                          paddingData(),
                          Text(
                              'Free',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Constants.textColor,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  paddingData(),
//                  Card(
//                    child: ListTile(
//                      title: Text('Details',
//                          style: TextStyle(
//                              fontSize: 18,
//                              color: Constants.textColor,
//                              fontWeight: FontWeight.w700
//                          )),
//                      subtitle: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          paddingData(),
//                          Text(
//                              '• ${deals.details}',
//                              style: TextStyle(
//                                  fontSize: 15,
//                                  color: Constants.textColor,
//                                  fontWeight: FontWeight.w300
//                              )
//                          ),
//                          paddingData(),
//                          Text(
//                              '• ${deals.details}',
//                              style: TextStyle(
//                                  fontSize: 15,
//                                  color: Constants.textColor,
//                                  fontWeight: FontWeight.w300
//                              )
//                          ),
//                          paddingData(),
//                          Text(
//                              '• ${deals.details}',
//                              style: TextStyle(
//                                  fontSize: 15,
//                                  color: Constants.textColor,
//                                  fontWeight: FontWeight.w300
//                              )
//                          ),
//                          paddingData(),
//                          Text(
//                              '• ${deals.details}',
//                              style: TextStyle(
//                                  fontSize: 15,
//                                  color: Constants.textColor,
//                                  fontWeight: FontWeight.w300
//                              )
//                          ),
//                          paddingData(),
//                          Text(
//                              '• ${deals.details}',
//                              style: TextStyle(
//                                  fontSize: 15,
//                                  color: Constants.textColor,
//                                  fontWeight: FontWeight.w300
//                              )
//                          ),
//                          paddingData(),
//                          Text(
//                              '• ${deals.details}',
//                              style: TextStyle(
//                                  fontSize: 15,
//                                  color: Constants.textColor,
//                                  fontWeight: FontWeight.w300
//                              )
//                          ),
//                          paddingData(),
//                        ],
//                      ),
//                    ),
//                  ),
                  paddingData(),
                  Card(
                    child: ListTile(
                      title: Text('Points to Note',
                          style: TextStyle(
                              fontSize: 20,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w600
                          )),
                      subtitle: ListView.builder(
                        shrinkWrap: true,
                        itemCount: deals.tnc.length,
                        padding: EdgeInsets.all(8.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Text(
                              '• ${tnc[index]}',
                              style: TextStyle(
                                color: Constants.test,
                              )
                          );
                        },
                      ),
                    ),
                  ),
                  paddingData(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: FlatButton(
                      color: Colors.white,
                      onPressed: () {

                      },
                      child:ListTile(
                        contentPadding: const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
                        title: FlatButton(
                          color: Colors.white,
                          onPressed: (){},
                          child: const Text(
                            'SHOW COUPON CODE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        subtitle: Visibility(
                          child: Text(
                            'ELSE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: buttonPressed,
                        ),
                      ),
                    ),
                  )
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
      padding: const EdgeInsets.only(bottom: 5.0),
    );
  }

}