import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:biteme/utilities/server_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:biteme/utilities/viewport_offset.dart';
import 'package:biteme/widgets/reward_template.dart';

class RewardsChild extends StatefulWidget {
  FirebaseUser user;
  var signOutGoogle;
  String path;

  RewardsChild({this.user, this.signOutGoogle, this.path});

  @override
  _RewardsChildState createState() =>
      _RewardsChildState(user: user, signOutGoogle: signOutGoogle, path: path);
}

class _RewardsChildState extends State<RewardsChild> {
  final FirebaseUser user;
  final Function signOutGoogle;
  String path;
  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController =
      new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 75; // set bottom bar height
  double _bottomBarOffset = 0;
  List<RewardTemplate> rewardTemplate = [];
  List<int> purchasedTags = [];
  List<int> purchasedDiscounts = [];

  _RewardsChildState({this.user, this.signOutGoogle, this.path});

  @override
  void initState() {
    super.initState();
    myScroll();
    loadTagList();
    var ref = FirebaseDatabase.instance
        .reference()
        .child("rewards/" + path)
        .orderByChild('credits');
    ref.once().then((snapshot) {
      var keys = snapshot.value.keys;
      var data = snapshot.value;

      rewardTemplate.clear();

      for (var individualKeys in keys) {
        RewardTemplate rewTemp = new RewardTemplate(
            data[individualKeys]['name'], data[individualKeys]['credits']);

        rewardTemplate.add(rewTemp);
        print(individualKeys);
      }

      rewardTemplate.sort((a, b) => a.credits.compareTo(b.credits));
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

  int _numCredits = 0;
  int _getCredits() {
    //DataSnapshot snapshot1;
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    ref.once().then((snapshot) {
      setState(() {
        _numCredits = snapshot.value['credits'];
      });
    });

    return _numCredits;
  }

  void loadTagList() async {
    DatabaseReference ref2 = FirebaseDatabase.instance
        .reference()
        .child("users/" + user.uid + "/tags_purchased");

    await ref2.once().then((snapshot) {
      if (snapshot.value != null)
        setState(() {
          purchasedTags = new List<int>.from(snapshot.value);
        });
    });
  }

  void rewardTap(RewardTemplate rewardTemplate, String path) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    await ref.once().then((snapshot) {
      setState(() {
        _numCredits = snapshot.value['credits'];
      });
    });

    print("STAGEE REACHED 1");

    _numCredits = _numCredits ?? 0;
    if (path == "Tags" && rewardTemplate.credits <= _numCredits) {
      DatabaseReference ref2 = FirebaseDatabase.instance
          .reference()
          .child("users/" + user.uid + "/tags_purchased");

      //ref.update({'credits': _numCredits, 'badge': name});
      bool alreadyReviewed = false;

      await ref2.once().then((snapshot) {
        //Binary search to find least element greater than the key

        if (snapshot.value == null)
          purchasedTags = [];
        else
          purchasedTags = new List<int>.from(snapshot.value);

        int lb = 0;
        int ub = purchasedTags.length;
        while (lb < ub) {
          int mid = ((lb + ub) / 2).floor();
          if (purchasedTags[mid].compareTo(rewardTemplate.credits) <= 0)
            lb = mid + 1;
          else
            ub = mid;
        }

        //Insert in the list if the productId does not already exist in it
        if (lb == 0)
          purchasedTags.insert(0, rewardTemplate.credits);
        else if (purchasedTags[lb - 1] == rewardTemplate.credits) {
          alreadyReviewed = true;
          ref.update({'badge': rewardTemplate.name});
          setState(() {
            rewardTemplate.name = "Tag Applied!";
          });
          print(rewardTemplate.name + "inside");
          return;
        } else {
          purchasedTags.insert(lb, rewardTemplate.credits);
        }

        _numCredits = _numCredits - rewardTemplate.credits;
        ref.update({'credits': _numCredits, 'badge': rewardTemplate.name});
        setState(() {
          rewardTemplate.name = "Tag Purchased!";
        });
        ref2.set(purchasedTags);
      });
    }
  }

  String _getName(RewardTemplate rewardTemplate) {
    String name = rewardTemplate.name;
    return name;
  }

  bool _hasPurchased(RewardTemplate rewardTemplate) {
    int lb = 0;
    int ub = purchasedTags.length ?? 0;
    while (lb < ub) {
      int mid = ((lb + ub) / 2).floor();
      if (purchasedTags[mid].compareTo(rewardTemplate.credits) <= 0)
        lb = mid + 1;
      else
        ub = mid;
    }

    if (lb == 0) return false;
    if (purchasedTags[lb - 1] == rewardTemplate.credits) {
      return true;
    } else {
      return false;
    }
  }

  Color _getColor(RewardTemplate rewardTemplate) {
    if (_getName(rewardTemplate) == "Tag Applied!")
      return Colors.blue;
    else if (_getName(rewardTemplate) == "Tag Purchased!")
      return Colors.red;
    else if (_hasPurchased(rewardTemplate))
      return Colors.grey;
    else
      return null;
  }

  Widget rewUI(RewardTemplate rewardTemplate) {
    return GestureDetector(
      onTap: () {
        if (_getName(rewardTemplate) != "Tag Applied!" &&
            _getName(rewardTemplate) != "Tag Purchased!")
          rewardTap(rewardTemplate, path);
        else
          print("Tap Declined");
      },
      child: new Card(
        color: _getColor(rewardTemplate),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10.0,
        margin: EdgeInsets.all(9.0),
        child: new Container(
          padding: new EdgeInsets.all(15.0),
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _getName(rewardTemplate),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'OpenSans',
                  ),
                  textAlign: TextAlign.center,
                ),
                new Text(
                  rewardTemplate.credits.toString() + " credits",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text(
          path,
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
      ),
      body: new Container(
        child: rewardTemplate.length == 0
            ? new Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : new ListView.builder(
                itemCount: rewardTemplate.length,
                itemBuilder: (_, index) {
                  return rewUI(rewardTemplate[index]);
                }),
      ),
    );
  }
}
