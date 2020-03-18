import 'dart:convert';

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
      statusBarColor: Color.fromRGBO(247, 228, 255, 0),
      statusBarIconBrightness: Brightness.dark
    ));
    return MaterialApp(
      title: 'Bite Me',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(58, 110, 207, 1),
        accentColor: Color.fromRGBO(220, 220, 255, 1),
        errorColor: Colors.pink[300],
        buttonColor: Colors.white,
        cardColor: Colors.white,
        canvasColor: Color.fromRGBO(225, 235, 245, 1),
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
      home: LoginPage(logOut: false,),
    );
  }
}