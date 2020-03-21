import 'package:biteme/models/product.dart';
import 'package:biteme/models/review.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/widgets/review_list.dart';
import 'package:biteme/widgets/add_review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProductReview extends StatefulWidget {
  final Product product;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProductReview({this.product, this.scaffoldKey});

  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {

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
                child: AddReview(
                    scaffoldKey: widget.scaffoldKey, productId: widget.product.getId,),
                onTap: () {},
                behavior: HitTestBehavior.opaque,
              ),
            ],
          );
        });
  }

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
            StreamBuilder(
                stream: FirebaseFunctions.getTraversedChild(
                    ['products', widget.product.getId, 'reviews']).onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else {
                    List<Review> _reviewsList = [];
                    Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
                    if (values != null)
                      values.forEach((key, value) {
                        _reviewsList
                            .add(Review.fromJson({'key': key, 'value': value}));
                      });
                    return ReviewList(
                      context: context,
                      reviewsList: _reviewsList,
                      productId: widget.product.getId,
                    );
                  }
                })
          ],
        ),
      ),
    ])));
  }
}
