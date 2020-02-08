import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class StarRating extends StatefulWidget{
  final double rating;
  final Function(double) callback;
  StarRating(this.rating,this.callback);
  @override
  createState() => StarRatingState();
}
class StarRatingState extends State<StarRating>{
  double rating;

  @override
  initState(){
    super.initState();
    rating=widget.rating;
  }
  bool change = false;
  @override
  Widget build(BuildContext context) {
    if(!change){
      rating=widget.rating;
    }
    return SmoothStarRating(
        allowHalfRating: true,
        onRatingChanged: (v) {
          rating = v;
          setState(() {
            change=true;
          });
          widget.callback(rating);
        },
        starCount: 5,
        rating: rating,
        size: 30.0,
        color: Colors.blueAccent,
        borderColor: Colors.blueGrey,
        spacing:0.0
    );
  }
}