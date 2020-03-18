import 'package:biteme/models/review.dart';
import 'package:flutter/material.dart';

class ReviewList extends StatelessWidget {
  final BuildContext context;
  List<Review> reviewsList;

  ReviewList({this.context, this.reviewsList}) {
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
                List<Widget> likesIconList = [];
                for (var v = 0; v < reviewsList[index].rating; v++)
                  likesIconList.add(Icon(
                    Icons.star,
                    size: 23,
                    color: Theme.of(context).textSelectionColor,
                  ));
                return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.only(
                        left: 12, right: 10, top: 10, bottom: 10),
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              child: Container(
                            child: Text(
                              reviewsList[index].title,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.fade,
                            ),
                          )),
                          Row(
                            children: likesIconList
                          )
                        ],
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            reviewsList[index].description,
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
                                    reviewsList[index].reviewer,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                      reviewsList[index].likes.toString() +
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
                                  child: Icon(
                                    Icons.thumb_up,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                  onPressed: () {},
                                ))
                          ],
                        ),
                      ),
                    ]));
              }),
    );
  }
}
