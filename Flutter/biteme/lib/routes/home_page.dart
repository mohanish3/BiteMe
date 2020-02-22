import 'package:biteme/routes/login_page.dart';
import 'package:biteme/widgets/profile_details.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:biteme/models/product.dart';
import 'package:biteme/widgets/products_list.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  HomePage({this.user, this.googleSignIn});

  _HomePageState createState() =>
      _HomePageState(user: user, googleSignIn: googleSignIn);
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); //Used for snackbars
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  TabController _tabController;

  List<Product> _productList;

  FirebaseDatabase database;
  DatabaseReference _userRef;

  int _selectedIndex;

  _HomePageState({this.user, this.googleSignIn}) {
    _selectedIndex = 0;
    database = new FirebaseDatabase();
    _userRef = database.reference().child('user');
    _productList = [
      Product(
          title: 'Snickers',
          imageUrl:
              'https://cdn.gymbeam.com/media/catalog/product/cache/926507dc7f93631a094422215b778fe0/s/n/snickers_hi-protein_peanut_butter.png'),
      Product(
          title: 'Kitkat',
          imageUrl:
              'https://image3.mouthshut.com/images/imagesp/925039961s.jpg')
    ];
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage(
              logOut: true,
            )));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = new TabController(length: 5, vsync: this);
    _tabController.addListener(_setSelectedIndex);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  void _displaySnackbar(BuildContext context, String text) {
    final snackbar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _setSelectedIndex() {
    setState(() {
      _selectedIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: Text(
          'Bite Me!',
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
            ),
            onPressed: () => _displaySnackbar(context, 'TODO yet!'),
          ),
        ],
      ),
      body: TabBarView(controller: _tabController, children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              ProductList(context: context, productList: _productList),
            ],
          ),
        ),
        Container(color: Colors.blue),
        Container(color: Colors.red),
        Container(color: Colors.amber),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(3.5),
          child: Card(
            elevation: 7,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ProfileDetails(user: user),
                  FlatButton(
                    onPressed: signOutGoogle,
                    child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.close,
                          color: Theme.of(context).errorColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(color: Theme.of(context).errorColor),
                        )
                      ],
                    )),
                  )
                ]),
          ),
        ),
      ]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(width: 0.5, color: Colors.blueGrey[800]),
        )),
        child: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).iconTheme.color,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Theme.of(context).textSelectionColor,
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              child: Text(
                'Home',
                overflow: TextOverflow.fade,
                textScaleFactor: 0.8,
              ),
            ),
            Tab(
              icon: Icon(Icons.search),
              child: Text(
                'Search',
                overflow: TextOverflow.fade,
                textScaleFactor: 0.8,
              ),
            ),
            Tab(
              icon: Icon(Icons.whatshot),
              child: Text(
                'Hot deals',
                overflow: TextOverflow.fade,
                textScaleFactor: 0.69,
              ),
            ),
            Tab(
              icon: Icon(Icons.attach_money),
              child: Text(
                'Rewards',
                overflow: TextOverflow.fade,
                textScaleFactor: 0.76,
              ),
            ),
            Tab(
              icon: Icon(Icons.person),
              child: Text(
                'Profile',
                overflow: TextOverflow.fade,
                textScaleFactor: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
