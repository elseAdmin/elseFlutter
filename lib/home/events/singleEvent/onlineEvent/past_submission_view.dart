import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';

class PastSubmissionView extends StatelessWidget {
  String imageUrl;
  String status;
  PastSubmissionView(String imageUrl, String status) {
    this.imageUrl = imageUrl;
    this.status = status;
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 2,
        ),
        child: (Column(
          children: <Widget>[
            Container(
                width: SizeConfig.blockSizeHorizontal * 80,
                height: SizeConfig.blockSizeVertical * 28,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageUrl,
                )),
            Container(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 12),
                ))
          ],
        )));
  }
}
