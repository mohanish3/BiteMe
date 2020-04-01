import 'package:biteme/models/product.dart';
import 'package:biteme/routes/bookmark_page.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/widgets/grid_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
  final FirebaseUser user;

  Feed({this.user});

  Future<List<Product>> getRecommendations() async {
    dynamic firebaseSnapshot = await FirebaseFunctions.getTraversedChild(['users', user.uid, 'recommendations']).once();
    List<dynamic> firebaseList = firebaseSnapshot.value;

    List<Product> _recommendedList = [];
    for (int i = 0; i < firebaseList.length; i++) {
      dynamic snapshot = await FirebaseFunctions.getTraversedChild(
          ['products', firebaseList[i]]).once();
      _recommendedList.add(Product.fromJson({'key': firebaseList[i], 'value': snapshot.value}));
    }
    return _recommendedList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            child: Column(children: <Widget>[
      CustomAppBar(
        icons: <Widget>[
          CustomIconButton(
              icon: Icons.bookmark,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BookmarkPage(user:user),
                  ))),
          CustomIconButton(icon: Icons.refresh, onPressed: () {})
        ],
      ),
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                "Bite Me!",
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                "Recommendations",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
            FutureBuilder(
                future:
                    getRecommendations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else {
                    List<Product> _recommendationsList = snapshot.data == null ? []: snapshot.data;
                    if(_recommendationsList.isEmpty)
                      return Text('No recommendation yet!\nPlease wait...');
                    return GridList(
                      productList: _recommendationsList,
                      user: user,
                    );
                  }
                }),
            Container(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                "Most reviewed",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
            StreamBuilder(
                stream:
                    FirebaseFunctions.getTraversedChild(['products']).onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else {
                    List<Product> _mostReviewedList = [];
                    Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
                    values.forEach((key, value) {
                      _mostReviewedList
                          .add(Product.fromJson({'key': key, 'value': value}));
                    });
                    return GridList(
                      productList: _mostReviewedList,
                      user: user,
                    );
                  }
                }),
          ],
        ),
      ),
    ])));
  }
}
