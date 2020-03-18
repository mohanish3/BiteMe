import 'package:biteme/models/product.dart';
import 'package:biteme/models/review.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/widgets/review_list.dart';
import 'package:biteme/widgets/add_review.dart';
import 'package:flutter/material.dart';

class ProductReview extends StatefulWidget {
  final Product product;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProductReview({this.product, this.scaffoldKey});

  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {

  _ProductReviewState() {
    reviewsList = [
      Review(
          title: 'AAAAAAAAAAAAAAA',
          description: 'BEST FOOD EVER!',
          rating: 5,
          reviewer: 'Mohanish Mhatre',
          likes: 1000),
      Review(
          title: 'Decent food',
          description: 'Alright!',
          rating: 3,
          reviewer: 'Omkar Kulkarni',
          likes: 100)
    ];
  }

  void _startAddReview(BuildContext ctx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Theme.of(ctx).cardColor,
        context: ctx,
        builder: (_) {
          return Wrap(
                children: <Widget>[
                  GestureDetector(
                    child: AddReview(addReview: _addReview, scaffoldKey: widget.scaffoldKey),
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                  ),
                ],
              );
        });
  }

  void _addReview(Review review) {
    setState(() {
      reviewsList.add(review);
    });
  }

  List<Review> reviewsList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            child: Column(children: <Widget>[
      CustomAppBar(
        icons: <Widget>[
          Text(
            "Reviews",
            style: TextStyle(
                fontSize: 35,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w400),
          ),
          CustomIconButton(
              icon: Icons.edit, onPressed: () => _startAddReview(context))
        ],
      ),
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ReviewList(context: context, reviewsList: reviewsList),
          ],
        ),
      ),
    ])));
  }
}
