import 'package:biteme/models/product.dart';
import 'package:biteme/tabs/product/product_details.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biteme/tabs/product/product_review.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  final bool searched;

  ProductPage({@required this.product, this.searched}) {
    FirebaseAuth.instance.currentUser().then((user) {
      DatabaseReference ref = FirebaseFunctions.getTraversedChild(
          ['users', user.uid, 'history', 'viewedProducts']);
      ref.once().then((snapshot) {
        //Binary search to find least element greater than the key
        List<dynamic> productsViewedList;
        if (snapshot.value == null)
          productsViewedList = [];
        else
          productsViewedList = new List<String>.from(snapshot.value);
        int lb = 0;
        int ub = productsViewedList.length;
        while (lb < ub) {
          int mid = ((lb + ub) / 2).floor();
          if (productsViewedList[mid].compareTo(product.getId) <= 0)
            lb = mid + 1;
          else
            ub = mid;
        }

        //Insert in the list if the productId does not already exist in it
        if (lb == 0)
          productsViewedList.insert(0, product.getId);
        else if (productsViewedList[lb - 1] == product.getId) {
          return;
        } else {
          productsViewedList.insert(lb, product.getId);
        }

        ref.set(productsViewedList);
      });

      if (searched) {
        ref = FirebaseFunctions.getTraversedChild(
            ['users', user.uid, 'history', 'searchedProducts']);
        ref.once().then((snapshot) {
          //Binary search to find least element greater than the key
          List<dynamic> productsSearchedList;
          if (snapshot.value == null)
            productsSearchedList = [];
          else
            productsSearchedList = new List<String>.from(snapshot.value);
          int lb = 0;
          int ub = productsSearchedList.length;
          while (lb < ub) {
            int mid = ((lb + ub) / 2).floor();
            if (productsSearchedList[mid].compareTo(product.getId) <= 0)
              lb = mid + 1;
            else
              ub = mid;
          }

          //Insert in the list if the productId does not already exist in it
          if (lb == 0)
            productsSearchedList.insert(0, product.getId);
          else if (productsSearchedList[lb - 1] == product.getId) {
            return;
          } else {
            productsSearchedList.insert(lb, product.getId);
          }

          ref.set(productsSearchedList);
        });
      }
    });
  }

  _ProductPageState createState() => _ProductPageState(product: product);
}

class _ProductPageState extends State<ProductPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Product product;

  TabController _tabController;
  int _selectedIndex;

  _ProductPageState({this.product}) {
    _selectedIndex = 0;
  }

  void _setSelectedIndex() {
    setState(() {
      _selectedIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(_setSelectedIndex);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
          child: TabBarView(controller: _tabController, children: [
        ProductDetails(product: product),
        ProductReview(
          product: product,
          scaffoldKey: _scaffoldKey,
        ),
        Container(color: Colors.blue)
      ])),
      bottomNavigationBar: Card(
        margin: EdgeInsets.all(0),
        elevation: 10,
        child: Container(
          child: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).iconTheme.color,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Theme.of(context).textSelectionColor,
            tabs: [
              Tab(
                icon: Icon(Icons.info_outline),
                child: Text(
                  'Details',
                  overflow: TextOverflow.fade,
                  textScaleFactor: 0.8,
                ),
              ),
              Tab(
                icon: Icon(Icons.star_border),
                child: Text(
                  'Reviews',
                  overflow: TextOverflow.fade,
                  textScaleFactor: 0.8,
                ),
              ),
              Tab(
                icon: Icon(Icons.money_off),
                child: Text(
                  'View deals',
                  overflow: TextOverflow.fade,
                  textScaleFactor: 0.69,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
