import 'package:biteme/models/product.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/widgets/search_results_list.dart';
import 'package:flutter/material.dart';

class BookmarkPage extends StatelessWidget {

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
                          icon: Icons.arrow_back_ios, onPressed: () => Navigator.of(context).pop()),
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
                      stream:
                      FirebaseFunctions.getTraversedChild(['products']).onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        else {
                          List<Product> _bookmarksList = [];
                          Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
                          values.forEach((key, value) {
                            _bookmarksList
                                .add(Product.fromJson({'key': key, 'value': value}));
                          });
                          return SearchResultsList(searchResultsList: _bookmarksList);
                        }
                      }),
                ])))
    );
  }
}
