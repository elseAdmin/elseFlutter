import 'package:else_app_two/basicElements/camera_impl.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class SingleEventScreen extends StatelessWidget {
  EventModel event;
  SingleEventScreen(EventModel event) {
    this.event = event;
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: SizeConfig.blockSizeVertical * 30,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(event.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      )),
                  background:
                      Image(fit: BoxFit.cover, image: NetworkImage(event.url))),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 2),
                      child: Text(event.description,
                          style: TextStyle(
                              fontSize: 16,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w300))),
                  Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 2),
                      child: Text(
                        "Submissions",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Constants.textColor,
                            fontSize: 18,
                            decoration: TextDecoration.underline),
                      )),
                  Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 13,
                          top: SizeConfig.blockSizeVertical * 2),
                      child: Row(children: <Widget>[
                        CameraImpl(),
                        Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            child: Text("Submit yours",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Constants.textColor,
                                    fontWeight: FontWeight.w400)))
                      ])),
                  Divider(
                      indent: SizeConfig.blockSizeHorizontal * 7,
                      endIndent: SizeConfig.blockSizeHorizontal * 7,
                      color: Colors.black87,
                      height: SizeConfig.blockSizeVertical * 5),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              delegate: SliverChildListDelegate(
                [
                  Card(color: Colors.green),
                  Card(color: Colors.yellow),
                  Card(color: Colors.orange),
                  Card(color: Colors.blue),
                  Card(color: Colors.red),
                  Card(color: Colors.blue),
                  Card(color: Colors.green),
                  Card(color: Colors.yellow),
                  Card(color: Colors.orange),
                  Card(color: Colors.blue),
                  Card(color: Colors.red),
                  Card(color: Colors.blue),
                  Card(color: Colors.green),
                  Card(color: Colors.yellow),
                  Card(color: Colors.orange),
                  Card(color: Colors.blue),
                  Card(color: Colors.red),

                  Card(color: Colors.red),
                  Card(color: Colors.blue),
                  Card(color: Colors.green),

                  Card(color: Colors.yellow),
                ],
              ),
            ),




            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Text("veiw more")
                  ]),
            ),
          ],
        ),
      ),
    );

    /* Container(
      child: Column(
        children: <Widget>[
          //upper fixed half
          Container(
            height: SizeConfig.blockSizeVertical * 30,
            child: Stack(fit: StackFit.passthrough, children: <Widget>[
              Image(fit: BoxFit.cover, image: NetworkImage(event.url)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    padding: EdgeInsets.only(
                        top: SizeConfig.backArrowButtonTopPad,
                        left: SizeConfig.backArrowButtonLeftPad),
                    child: Icon(Icons.arrow_back, color: Colors.white)),
              ),
            ]),
          ),

          //neeche ki list

          Container(
              color: Constants.mainBackgroundColor,
              height: SizeConfig.blockSizeVertical * 70,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(event.name,
                          style: TextStyle(
                              fontSize: 18,
                              color: Constants.textColor,
                              fontWeight: FontWeight.w300)),
                      Container(
                          padding:
                              EdgeInsets.all(SizeConfig.blockSizeVertical * 2),
                          child: Text(event.description,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Constants.textColor,
                                  fontWeight: FontWeight.w300))),
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 2),
                      child: Text(
                        "Submissions",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Constants.textColor,
                            fontSize: 15,
                            decoration: TextDecoration.underline),
                      )),
                  Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 13,
                          top: SizeConfig.blockSizeVertical * 2),
                      child: Row(children: <Widget>[
                        CameraImpl(),
                        Container(
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 5,
                            ),
                            child: Text("Submit yours",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Constants.textColor,
                                    fontWeight: FontWeight.w400)))
                      ])),
                  Divider(
                      indent: SizeConfig.blockSizeHorizontal * 7,
                      endIndent: SizeConfig.blockSizeHorizontal * 7,
                      color: Colors.black87,
                      height: SizeConfig.blockSizeVertical * 5),

                  CustomScrollView(
                    primary: false,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(20.0),
                        sliver: SliverGrid.count(
                          crossAxisSpacing: 10.0,
                          crossAxisCount: 2,
                          children: <Widget>[
                            const Text('He\'d have you all unravel at the'),
                            const Text('Heed not the rabble'),
                            const Text('Sound of screams but the'),
                            const Text('Who scream'),
                            const Text('Revolution is coming...'),
                            const Text('Revolution, they...'),
                          ],
                        ),
                      ),
                    ],
                  )
                 /* GridView.count(
                    physics: ScrollPhysics(),
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(100, (index) {
                      return Center(
                        child: Text(
                          'Item $index',
                        ),
                      );
                    }),
                  )*/





                ],
              ))
        ],
      ),
    );

    */
  }
}
