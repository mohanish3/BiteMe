import 'package:biteme/routes/login_page.dart';
import 'package:biteme/tabs/home/profile_details.dart';
import 'package:biteme/tabs/home/rewards_child.dart';
import 'package:biteme/tabs/home/feed.dart';
import 'package:biteme/tabs/home/search.dart';
import 'package:flutter/material.dart';
import 'package:biteme/tabs/home/rewards_main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;
  int selectedIndex;

  HomePage({this.user, this.googleSignIn, this.selectedIndex});

  _HomePageState createState() =>
      _HomePageState(user: user, googleSignIn: googleSignIn, selectedIndex: selectedIndex);
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); //Used for snackbars
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  TabController _tabController;

  int selectedIndex;

  _HomePageState({this.user, this.googleSignIn,this.selectedIndex}) {
    //_tabController.index = selectedIndex;
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
    _tabController = new TabController(length: 4, vsync: this, initialIndex: selectedIndex ?? 0,);
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
      selectedIndex = _tabController.index;
      print (selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).canvasColor,
      body: TabBarView(controller: _tabController, children: [
        Feed(user:user),
        SearchTab(
          scaffoldKey: _scaffoldKey,
          user: user,
        ),
        Rewards(user: user, signOutGoogle: signOutGoogle,),
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
                icon: Icon(Icons.attach_money),
                child: Text(
                  'Rewards',
                  overflow: TextOverflow.fade,
                  textScaleFactor: 0.6,
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
