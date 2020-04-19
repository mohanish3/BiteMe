import 'package:biteme/models/product.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  final FirebaseUser user;

  ProductDetails({this.product, this.user});

  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isBookmarked;
  List<String> bookmarks;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      CustomAppBar(
        icons: <Widget>[
          CustomIconButton(
              icon: Icons.arrow_back_ios,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          StreamBuilder(
            stream: FirebaseFunctions.getTraversedChild(
                ['users', widget.user.uid, 'history', 'bookmarks']).onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();
              else {
                bookmarks = snapshot.data.snapshot.value == null
                    ? []
                    : new List<String>.from(snapshot.data.snapshot.value);
                isBookmarked = widget.product
                    .getBookmarkStatus(bookmarks, widget.product.getId);
                return Container(
                    alignment: Alignment.topRight,
                    child: CustomIconButton(
                      color: Theme.of(context).primaryColor,
                      icon:
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      onPressed: () {
                        if (isBookmarked) {
                          setState(() {
                            widget.product.unBookmark(bookmarks,
                                widget.user.uid, widget.product.getId);
                          });
                        } else {
                          setState(() {
                            widget.product.bookmark(bookmarks, widget.user.uid,
                                widget.product.getId);
                          });
                        }
                      },
                    ));
              }
            },
          )
        ],
      ),
      Container(
        width: MediaQuery.of(context).size.width / 2,
        margin: EdgeInsets.fromLTRB(100, 0, 100, 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
        ),
        child: FadeInImage.assetNetwork(
          width: 5,
          fadeInCurve: Curves.fastOutSlowIn,
          placeholder: 'assets/images/product_placeholder.png',
          image: widget.product.getImageUrl,
          fit: BoxFit.fill,
        ),
      ),
      Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(30, 25, 10, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Text(
                        widget.product.getTitle,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.product.getDescription,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'OpenSans'),
                      )
                    ]),
                  ))
                ])),
      )
    ]);
  }
}
