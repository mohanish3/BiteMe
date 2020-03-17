import 'package:biteme/models/product.dart';
import 'package:biteme/widgets/appbar.dart';
import 'package:biteme/widgets/customiconbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  ProductDetails({@required this.product});

  _ProductDetailsState createState() => _ProductDetailsState(product: product);
}

class _ProductDetailsState extends State<ProductDetails>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final Product product;

  TabController _tabController;
  int _selectedIndex;

  _ProductDetailsState({this.product}) {
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
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
          child: TabBarView(controller: _tabController, children: [
        Column(children: <Widget>[
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
        ]),
        Container(color: Colors.yellow),
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
