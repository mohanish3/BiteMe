import 'dart:convert';

import 'package:biteme/models/product.dart';
import 'package:biteme/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo[700],
    ));
    return MaterialApp(
      title: 'Bite Me',
      theme: ThemeData(
        primaryColor: Colors.indigo[700],
        bottomAppBarColor: Colors.indigo[700],
        accentColor: Colors.blue[800],
        errorColor: Colors.pink,
        buttonColor: Colors.indigo,
        cardColor: Colors.white,
        textSelectionColor: Colors.amber[700],
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        fontFamily: 'Quicksand',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); //Used for snackbars

  List<Product> _productList;

  FirebaseDatabase database;
  DatabaseReference _userRef;

  int _selectedIndex;

  _HomePageState() {
    _selectedIndex = 0;
    database = new FirebaseDatabase();
    _userRef = database.reference().child('user');
    _productList = [Product(title: 'Snickers', imageUrl: 'https://cdn.gymbeam.com/media/catalog/product/cache/926507dc7f93631a094422215b778fe0/s/n/snickers_hi-protein_peanut_butter.png'),
      Product(title: 'Kitkat', imageUrl: 'https://image3.mouthshut.com/images/imagesp/925039961s.jpg')];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(248, 255, 255, 255),
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
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ProductList(context: context,
                productList: _productList),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Recommendations'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
