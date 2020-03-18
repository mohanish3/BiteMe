import 'package:biteme/models/product.dart';
import 'package:biteme/tabs/product/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biteme/tabs/product/product_review.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  ProductPage({@required this.product});

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
        ProductReview(product: product, scaffoldKey: _scaffoldKey,),
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
