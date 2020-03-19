import 'package:biteme/models/review.dart';
import 'package:biteme/widgets/review_card.dart';
import 'package:flutter/material.dart';

class ReviewList extends StatelessWidget {
  final String productId;
  final BuildContext context;
  List<Review> reviewsList;

  ReviewList({this.context, this.reviewsList, this.productId}) {
    if (reviewsList == null) reviewsList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      child: reviewsList.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No reviews yet!',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                ),
              ],
            )
          : ListView.builder(
              itemCount: reviewsList.length,
              itemBuilder: (context, index) {
                return ReviewCard(review: reviewsList[index], productId: productId,);
              }),
    );
  }
}
