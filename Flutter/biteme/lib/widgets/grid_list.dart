import 'package:biteme/models/product.dart';
import 'package:biteme/widgets/product_card.dart';
import 'package:flutter/material.dart';

class GridList extends StatelessWidget {
  List<Product> productList;
  final String title;

  GridList({this.productList, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
        ),
      ),
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
                .map((product) => ProductCard(product: product))
                .toList()),
      )
    ]);
  }
}
