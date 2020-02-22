import 'dart:convert';

import 'package:biteme/models/product.dart';
import 'package:biteme/widgets/product_details.dart';
import 'package:flutter/material.dart';

//Gets the ListView for each activity running
class ProductList extends StatelessWidget {
  final List<Product> productList;
  final BuildContext context;

  ProductList({this.context, this.productList});

  void productDetails(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetails(
                  product: productList[index],
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.88,
        child: productList.isEmpty
            ? Center(
                child: Column(
                children: <Widget>[
                  Text(
                    'No Activities added yet!',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      height: 100,
                      child: Image.asset('assets/images/waiting.png',
                          fit: BoxFit.cover)),
                ],
              ))
            : ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  Product product = productList[index];
                  return Card(
                    elevation: 7,
                    child: Container(
                      child: ListTile(
                        onTap: () => productDetails(index),
                        title: Text(
                          product.getTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                        contentPadding: EdgeInsets.all(1),
                        subtitle: Text('Available'),
                        leading: Container(
                          padding: EdgeInsets.all(3),
                          child: Image.network(
                            product.getImageUrl == null
                                ? ''
                                : product.getImageUrl,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return CircularProgressIndicator(
                                  backgroundColor: Colors.blueGrey[200],
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                );
                            },
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () => {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
