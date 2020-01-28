import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WinnerSectionView extends StatefulWidget {
  final String eventUid;
  const WinnerSectionView(this.eventUid);
  @override
  WinnerSectionViewState createState() => WinnerSectionViewState();
}

class WinnerSectionViewState extends State<WinnerSectionView> {
  List<String> winnerImagesUrls = List();
  @override
  void initState() {
    DatabaseManager()
        .getWinnerSubmissionForOnlineEvent(widget.eventUid, winnerFound);
    super.initState();
  }

  winnerFound(List<String> imageUrls) {
    setState(() {
      winnerImagesUrls = imageUrls;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (winnerImagesUrls.isNotEmpty) {
      return SliverPadding(
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 1,
              right: SizeConfig.blockSizeHorizontal * 1,
              bottom: SizeConfig.blockSizeVertical * 3),
          sliver: SliverGrid(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 1,
                        right: SizeConfig.blockSizeHorizontal * 1,
                        bottom: SizeConfig.blockSizeVertical * 1),
                    color: Constants.mainBackgroundColor,
                    child: CachedNetworkImage(
                        fit: BoxFit.cover, imageUrl: winnerImagesUrls[index]));
              },
              childCount: winnerImagesUrls.length,
            ),
          ));
    } else {
      return SliverPadding(
          padding: EdgeInsets.only(
          bottom: SizeConfig.blockSizeVertical * 5),
    sliver:SliverList(
        delegate: SliverChildListDelegate([
          Center(
            child: Text('The winners will be announced anytime soon now')
          )
        ]),
      ));
    }
  }
}
