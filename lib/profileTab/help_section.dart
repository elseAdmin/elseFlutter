import 'package:else_app_two/profileTab/help_data.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:else_app_two/utils/Contants.dart';

class HelpSection extends StatelessWidget {
  final int index;

  HelpSection({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        title: Text('Help',
            style: TextStyle(
              color: Constants.navBarButton,
              fontSize: 18,
            )),
        iconTheme: IconThemeData(
          color: Constants.navBarButton, //change your color here
        ),
        backgroundColor: Constants.titleBarBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
                child: Text("FAQ", style: TextStyle(fontSize: 20))),
            HelpSectionData(),
          ],
        ),
      ),
    );
  }
}

class HelpSectionData extends StatefulWidget {
  @override
  _HelpSectionData createState() => _HelpSectionData();
}

class _HelpSectionData extends State<HelpSectionData> {
  final HelpDataList helpDataListClass = HelpDataList();
  List<HelpData> _helpDataList;

  @override
  void initState() {
    super.initState();
    _helpDataList = helpDataListClass.getHelpData();
  }

  _onExpansion(int index, bool isExpanded) {
    setState(() {
      _helpDataList[index].expanded = !_helpDataList[index].expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> myExpansionPanelList = [];
    for (int i = 0; i < _helpDataList.length; ++i) {
      var _expansionData = _helpDataList[i];
      myExpansionPanelList.add(ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
                child: Text(_expansionData.title,
                    style: TextStyle(fontSize: 14.0)));
          },
          body: Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
              child:
                  Text(_expansionData.body, style: TextStyle(fontSize: 12.0))),
          isExpanded: _expansionData.expanded));
    }
    return Container(
      child: new ExpansionPanelList(
        children: myExpansionPanelList,
        expansionCallback: _onExpansion,
      ),
    );
  }
}
