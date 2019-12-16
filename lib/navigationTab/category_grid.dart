import 'package:cached_network_image/cached_network_image.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget{

  final List categoryList = ['FASHION', 'BEAUTY', 'KIDS', 'ELECTRONICS',
    'HOME FURNISHING', 'RESTAURANTS', 'PUBS', 'ENTERTAINMENT'];

  final List imageUrls = [
    "https://firebasestorage.googleapis.com/v0/b/elseconsumerdatabase.appspot.com/o/unityOneRohini%2Fcategory%2FFashion.jpg?alt=media&token=bd3f4e3b-9ef8-4b84-9088-8d0a7ddd4383",
    "https://firebasestorage.googleapis.com/v0/b/elseconsumerdatabase.appspot.com/o/unityOneRohini%2Fcategory%2FBeauty.jpg?alt=media&token=69ac03a2-deb9-4f4f-8a10-9a2c4c7c100e",
    "https://firebasestorage.googleapis.com/v0/b/elseconsumerdatabase.appspot.com/o/unityOneRohini%2Fcategory%2FKids.jpg?alt=media&token=beedd32a-b01e-4136-823e-a149b7de52a4",
    "https://firebasestorage.googleapis.com/v0/b/elseconsumerdatabase.appspot.com/o/unityOneRohini%2Fcategory%2FElectronics.jpg?alt=media&token=a28b1a2d-0d16-4dbf-ab36-d4cb7af7b894",
    "https://firebasestorage.googleapis.com/v0/b/elseconsumerdatabase.appspot.com/o/unityOneRohini%2Fcategory%2FHome%20Furnishing.jpeg?alt=media&token=12e38d11-13bd-4166-8e1a-94177e339525",
    "https://firebasestorage.googleapis.com/v0/b/elseconsumerdatabase.appspot.com/o/unityOneRohini%2Fcategory%2FRestaurant.jpg?alt=media&token=5bb1d6ad-f16d-46ae-a91a-603ccd2ba65f",
    "https://firebasestorage.googleapis.com/v0/b/elseconsumerdatabase.appspot.com/o/unityOneRohini%2Fcategory%2FPubs.jpg?alt=media&token=7b57db75-6cba-4381-90af-bd67e77e6ff4",
    "https://firebasestorage.googleapis.com/v0/b/elseconsumerdatabase.appspot.com/o/unityOneRohini%2Fcategory%2FEntertainment.jpg?alt=media&token=8e5d0eee-97aa-4836-a0d2-c385526c4371"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        margin: EdgeInsets.all(10),
        child: GridView.builder(
            itemCount: categoryList.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index){
              return Card(
                color: Constants.mainBackgroundColor,
                child: GestureDetector(
                  onTap: () {
                    // add next tb here
                  },
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.5,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: imageUrls[index],
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        child: Center(
                          child:  Text(categoryList[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
    );
  }
}