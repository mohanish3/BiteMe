import 'package:biteme/models/product.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/widgets/search_results_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookmarkPage extends StatelessWidget {
  final FirebaseUser user;

  BookmarkPage({this.user});

  getBookmarks(List<dynamic> firebaseList) async {
    List<Product> _bookmarksList = [];
    for (int i = 0; i < firebaseList.length; i++) {
      dynamic snapshot = await FirebaseFunctions.getTraversedChild(
          ['products', firebaseList[i]]).once();
      _bookmarksList.add(Product.fromJson({'key': firebaseList[i], 'value': snapshot.value}));
    }
    return _bookmarksList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
            child: Container(
                child: Column(children: <Widget>[
          CustomAppBar(
            icons: <Widget>[
              CustomIconButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: () => Navigator.of(context).pop()),
              Text(
                'Bookmarks',
                style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          StreamBuilder(
              stream: FirebaseFunctions.getTraversedChild(
                  ['users', user.uid, 'bookmarks']).onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else {
                  List<dynamic> firebaseList =
                      snapshot.data.snapshot.value == null
                          ? []
                          : snapshot.data.snapshot.value;
                  return FutureBuilder(
                    future: getBookmarks(firebaseList),
                    builder: (context, childSnapshot) {
                      if (childSnapshot.connectionState ==
                          ConnectionState.waiting)
                        return CircularProgressIndicator();
                      else
                        return SearchResultsList(
                            searchResultsList: childSnapshot.data,
                        user:user);
                    },
                  );
                }
              }),
        ]))));
  }
}
