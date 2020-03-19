import 'package:biteme/models/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  final Review review;
  final String productId;

  ReviewCard({this.review, this.productId});

  @override
  _ReviewCardState createState() => _ReviewCardState(review: review);
}

class _ReviewCardState extends State<ReviewCard> {
  Map<String, dynamic> reviewData;
  FirebaseUser user;
  final Review review;
  bool isLiked;

  _ReviewCardState({this.review}) {
    isLiked = false;
    reviewData = review.toJson();
  }

  Future<FirebaseUser> getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> likesIconList = [];
    for (var v = 0; v < review.rating; v++)
      likesIconList.add(Icon(
        Icons.star,
        size: 23,
        color: Theme.of(context).textSelectionColor,
      ));
    return FutureBuilder<FirebaseUser>(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          else {
            isLiked = review.hasUserLiked(user.uid);
            return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    EdgeInsets.only(left: 12, right: 10, top: 10, bottom: 10),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                          child: Container(
                        child: Text(
                          review.title,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      )),
                      Row(children: likesIconList)
                    ],
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        review.description,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      )),
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                review.authorName,
                                style: TextStyle(
                                    fontSize: 13, fontStyle: FontStyle.italic),
                              ),
                              Text(
                                  review.likes.length.toString() +
                                      ' people like this.',
                                  style: TextStyle(fontSize: 13)),
                            ]),
                        Container(
                            width: 35,
                            height: 35,
                            margin: EdgeInsets.only(right: 2),
                            alignment: Alignment.center,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: isLiked
                                  ? Icon(
                                      Icons.thumb_up,
                                      color: Colors.green,
                                      size: 25,
                                    )
                                  : Icon(
                                      Icons.thumb_up,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                              onPressed: () {
                                if (isLiked) {
                                  setState(() {
                                    review.unlikeReview(
                                        user.uid, widget.productId);
                                    isLiked = false;
                                  });
                                } else {
                                  setState(() {
                                    review.likeReview(
                                        user.uid, widget.productId);
                                    isLiked = true;
                                  });
                                }
                              },
                            ))
                      ],
                    ),
                  ),
                ]));
          }
        });
  }
}
