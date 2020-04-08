import 'package:firebase_auth/firebase_auth.dart';
import 'package:biteme/utilities/server_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:biteme/utilities/viewport_offset.dart';
import 'package:biteme/widgets/custom_app_bar.dart';

class RewardTemplate {
  String name;
  RewardTemplate(this.name);
}

class RewardsMain extends StatefulWidget {
  FirebaseUser user;
  var signOutGoogle;

  RewardsMain({this.user, this.signOutGoogle});

  @override
  _RewardsMainState createState() =>
      _RewardsMainState(user: user, signOutGoogle: signOutGoogle);
}

class _RewardsState extends State<Rewards> {
  final FirebaseUser user;
  final Function signOutGoogle;
  bool _showAppbar = true; //this is to show app bar
ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
bool isScrollingDown = false;
bool _show = true;
double bottomBarHeight = 75; // set bottom bar height
double _bottomBarOffset = 0;
List<RewardTemplate> rewardTemplate = [];

  _RewardsState({this.user, this.signOutGoogle});


  @override
  void initState() {
    super.initState();
myScroll();
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("rewards/tags");
    ref.once().then((snapshot) {
      var keys = snapshot.value.keys;
      var data = snapshot.value;

      rewardTemplate.clear();

      for (var individualKeys in keys) {
        RewardTemplate rewTemp = new RewardTemplate(
            data[individualKeys]['name'], data[individualKeys]['credits']);

        rewardTemplate.add(rewTemp);
      }

      setState(() {
        //print ("Length = $rewTemp.length");
      });
    });
  }

  @override
void dispose() { 
  _scrollBottomBarController.removeListener(() {});
  super.dispose();
}

void showBottomBar() {
  setState(() {
    _show = true;
  });
}

void hideBottomBar() {
  setState(() {
    _show = false;
  });
}

void myScroll() async {
  _scrollBottomBarController.addListener(() {
    if (_scrollBottomBarController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown) {
        isScrollingDown = true;
        _showAppbar = false;
        hideBottomBar();
      }
    }
    if (_scrollBottomBarController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (isScrollingDown) {
        isScrollingDown = false;
        _showAppbar = true;
        showBottomBar();
      }
    }
  });
}

  Widget rewUI(String name, int credits) {
    return new Card(
        elevation: 10.0,
        margin: EdgeInsets.all(10.0),
        child: new Container(
            padding: new EdgeInsets.all(15.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'OpenSans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  new Text(
                    credits.toString() + " credits",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: _showAppbar ? new AppBar(
          title: new Text(
            "Rewards",
            style: TextStyle(
                fontSize: 35,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          toolbarOpacity: 0.0,
          bottomOpacity: 0.0,
          elevation: 0,
        ) : PreferredSize(
      child: Container(),
      preferredSize: Size(0.0, 0.0),
        ),
        body: new Container(
            child: rewardTemplate.length == 0
                ? new Text("No Rewards Available, sorry.")
                : new ListView.builder(
                    itemCount: rewardTemplate.length,
                    itemBuilder: (_, index) {
                      return rewUI(rewardTemplate[index].name,
                          rewardTemplate[index].credits);
                    })));
  }
}
