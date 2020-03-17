import 'package:biteme/models/product.dart';
import 'package:biteme/routes/product_details.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({@required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(
                        product: product,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Theme.of(context).canvasColor, blurRadius: 15, spreadRadius: 10),
            ],
          ),
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: <Widget>[
              FadeInImage.assetNetwork(
                fadeInCurve: Curves.fastOutSlowIn,
                placeholder: 'assets/images/product_placeholder.png',
                image: product.getImageUrl == null ? '' : product.getImageUrl,
                width: MediaQuery.of(context).size.height * 0.2,
                height: MediaQuery.of(context).size.height * 0.8 / 5,
              ),
              Text(product.getTitle
              , style: TextStyle(fontSize: 25)),
              Text("Available"
                , style: TextStyle(fontSize: 15)),
            ],
          ),
        ));
  }
}
