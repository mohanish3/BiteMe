import 'package:biteme/models/product.dart';
import 'package:biteme/widgets/product_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GridList extends StatelessWidget {
  List<Product> productList;
  final FirebaseUser user;

  GridList({this.productList, this.user});

  @override
  Widget build(BuildContext context) {
    return productList.isEmpty ? Container() : Column(children: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .3,
        child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 4 / 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20),
            scrollDirection: Axis.horizontal,
            children: productList
                .map((product) => ProductCard(product: product, user: user, searched: false, bookmarkable: false))
                .toList()),
      )
    ]);
  }
}
