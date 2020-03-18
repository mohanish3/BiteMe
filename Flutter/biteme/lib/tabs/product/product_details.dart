import 'package:biteme/models/product.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  ProductDetails({this.product});

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
          CustomIconButton(icon: Icons.refresh, onPressed: () {})
        ],
      ),
      Container(
        width: MediaQuery.of(context).size.width / 2,
        margin: EdgeInsets.fromLTRB(100, 20, 100, 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
        ),
        child: FadeInImage.assetNetwork(
          width: 5,
          fadeInCurve: Curves.fastOutSlowIn,
          placeholder: 'assets/images/product_placeholder.png',
          image: product.getImageUrl,
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
                Text(
                  product.getTitle,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'OpenSans'),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          )),
    ]);
  }
}
