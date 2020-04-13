import 'dart:math';

import 'package:biteme/routes/home_page.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactPage extends StatelessWidget {
  bool logOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(25),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.all(50),
              child: Text("Developed in BITS Goa, with love."),
            ),
          ],
        ),
      ),
    );
  }
}

class CreditsHelpPage extends StatelessWidget {
  bool logOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(25),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.all(50),
              child: Text("You can do a lot with your credits! \nFind a few details here!"),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewHelpPage extends StatelessWidget {
  bool logOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(25),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              margin: EdgeInsets.all(50),
              child: Text("Find reviews help here! \nFind a few details here!"),
            ),
          ],
        ),
      ),
    );
  }
}
