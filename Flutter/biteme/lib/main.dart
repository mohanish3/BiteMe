import 'dart:convert';

import 'package:biteme/routes/home_page.dart';
import 'package:biteme/routes/login_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
        buttonColor: Colors.white,
        cardColor: Colors.white,
        canvasColor: Color.fromARGB(248, 255, 255, 255),
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
      home: LoginPage(),
    );
  }
}