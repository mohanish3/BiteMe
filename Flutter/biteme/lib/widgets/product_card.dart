import 'package:biteme/models/product.dart';
import 'package:biteme/routes/product_page.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final FirebaseUser user;

  ProductCard({@required this.product, this.user});

  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isBookmarked;
  List<String> bookmarks;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductPage(
                        product: widget.product,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: <Widget>[
              Stack(children: <Widget>[
                FadeInImage.assetNetwork(
                  fadeInCurve: Curves.fastOutSlowIn,
                  placeholder: 'assets/images/product_placeholder.png',
                  image: widget.product.getImageUrl == null
                      ? ''
                      : widget.product.getImageUrl,
                  width: MediaQuery.of(context).size.height * 0.2,
                  height: MediaQuery.of(context).size.height * 0.8 / 5,
                ),
                StreamBuilder(
                  stream: FirebaseFunctions.getTraversedChild(['users', widget.user.uid, 'bookmarks']).onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return CircularProgressIndicator();
                    else {
                      bookmarks = snapshot.data.snapshot.value == null ? [] : new List<String>.from(snapshot.data.snapshot.value);
                      isBookmarked = widget.product.getBookmarkStatus(bookmarks, widget.product.getId);
                      return Container(
                          alignment: Alignment.topRight,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: isBookmarked
                                ? Icon(
                                    Icons.bookmark,
                                    color: Theme.of(context).primaryColor,
                                    size: 25,
                                  )
                                : Icon(
                                    Icons.bookmark_border,
                                    color:Theme.of(context).primaryColor,
                                    size: 25,
                                  ),
                            onPressed: () {
                              print(isBookmarked);
                              if (isBookmarked) {
                                setState(() {
                                  widget.product.unBookmark(bookmarks, widget.user.uid, widget.product.getId);
                                });
                              } else {
                                setState(() {
                                  widget.product.bookmark(bookmarks, widget.user.uid, widget.product.getId);
                                });
                              }
                            },
                          ));
                    }
                  },
                ),

              ]),
              Text(widget.product.getTitle, style: TextStyle(fontSize: 25)),
              Text("Available", style: TextStyle(fontSize: 15)),
            ],
          ),
        ));
  }
}
