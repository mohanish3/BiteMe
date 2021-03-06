import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:biteme/tabs/home/rewards_child.dart';

class Rewards extends StatefulWidget {
  FirebaseUser user;
  var signOutGoogle;

  Rewards({this.user, this.signOutGoogle});

  @override
  _RewardsState createState() =>
      _RewardsState(user: user, signOutGoogle: signOutGoogle);
}

class _RewardsState extends State<Rewards> {
  final FirebaseUser user;
  final Function signOutGoogle;
  List<dynamic> rewardTemplate = [];

  _RewardsState({this.user, this.signOutGoogle});

  @override
  void initState() {
    super.initState();
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("rewards");
    ref.once().then((snapshot) {
      var keys = snapshot.value.keys;

      rewardTemplate.clear();

      for (var individualKeys in keys) {
        rewardTemplate.add(individualKeys.toString());
      }

      setState(() {
        //print ("Length = $rewTemp.length");
      });
    });
  }

  Widget rewUI2(String name) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            RewardsChild(user: user, signOutGoogle: signOutGoogle, path: name),
      )),
      child: new Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
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
        ),
        body: new Container(
            child: rewardTemplate.length == 0
                ? new Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : new ListView.builder(
                    itemCount: rewardTemplate.length,
                    itemBuilder: (_, index) {
                      return rewUI2(rewardTemplate[index].toString());
                    })));
  }
}
