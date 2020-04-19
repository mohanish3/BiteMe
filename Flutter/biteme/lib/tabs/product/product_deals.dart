import 'dart:convert';

import 'package:biteme/models/product.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProductDeals extends StatelessWidget {
  final Product product;
  List<List<String>> deals = [];

  ProductDeals({this.product});

  getDeals() async {
    DataSnapshot snapshot = await FirebaseFunctions.getTraversedChild(
        ['products', product.id, 'source']).once();
    for (String key in snapshot.value.keys) {
      deals.add(List.from([
        key[0].toUpperCase() + key.substring(1),
        snapshot.value[key]['price'].toString()
      ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return SafeArea(
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: deals.length,
                      itemBuilder: (context, index) {
                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Text(
                                deals[index][0],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    color: Colors.black87),
                                overflow: TextOverflow.fade,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              trailing: Text(
                                deals[index][1],
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: Colors.black87),
                                overflow: TextOverflow.fade,
                              ),
                            ));
                      })));
      },
    );
  }
}
