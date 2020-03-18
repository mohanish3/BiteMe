import 'package:biteme/routes/login_page.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/widgets/grid_list.dart';
import 'file:///C:/Storage/Personal/Coding/Github/BiteMe/Flutter/biteme/lib/tabs/home/profile_details.dart';
import 'file:///C:/Storage/Personal/Coding/Github/BiteMe/Flutter/biteme/lib/tabs/home/search.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:biteme/models/product.dart';

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
      body: TabBarView(controller: _tabController, children: [
        SafeArea(
            child: Container(
                child: Column(children: <Widget>[
          CustomAppBar(
            icons: <Widget>[
              CustomIconButton(icon: Icons.star, onPressed: () {}),
              CustomIconButton(icon: Icons.refresh, onPressed: () {})
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Bite Me!",
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400),
                  ),
                ),
                GridList(
                  title: "Recommendations",
                  productList: _productList,
                ),
                GridList(
                  title: "Most reviewed",
                  productList: _productList,
                ),
              ],
            ),
          ),
        ]))),
        SearchTab(scaffoldKey: _scaffoldKey,),
        Container(color: Colors.red),
        Container(color: Colors.amber),
        ProfileDetails(user: user, signOutGoogle: signOutGoogle)
      ]),
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
      ),
    );
  }
}
