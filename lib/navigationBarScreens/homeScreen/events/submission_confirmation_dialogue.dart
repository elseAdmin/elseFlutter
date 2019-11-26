import 'dart:io';

import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmissionConfirmation extends StatelessWidget{

  final File image;
  final Function(File) callback;
  const SubmissionConfirmation(this.image,this.callback);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Container(
        height: SizeConfig.blockSizeVertical*43,
        width: SizeConfig.blockSizeHorizontal*70,
        child: Column(
          children: <Widget>[
            Container(
                color: Colors.transparent,
                height: SizeConfig.blockSizeVertical*30,
                child:Image(fit:BoxFit.cover,image: FileImage(this.image))),
            Container(
                height: SizeConfig.blockSizeVertical*7,
              padding:EdgeInsets.all(SizeConfig.blockSizeHorizontal),
                child:Text("Post submission, content verification will take around 1-2 hours for your image to be publically visible. We take privacy seriously.",style:TextStyle(fontSize: 11))),
            Container(
                height: SizeConfig.blockSizeVertical*5,
                child:
               Row(
                   mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child:Text("Cancel")
            ),GestureDetector(
                     onTap: (){
                       //pass back the file for submission section to re-render and display confirmed image
                        this.callback(this.image);
                        Navigator.pop(context);
                     },
                     child:Text("Submit")
                 )
            ])

            )

          ],
        ),
      ),
    );
  }

}