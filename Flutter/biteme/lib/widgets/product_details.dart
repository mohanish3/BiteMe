import 'package:biteme/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  ProductDetails({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          'Product',
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
          child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(width: 4, color: Theme.of(context).primaryColor)),
          child: ClipOval(
            child: Image.network(
              product.getImageUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Text(
          product.getTitle,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        )
      ])),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            title: Text('Details'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            title: Text('View deals'),
          ),
        ],
        currentIndex: 0,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }
}
