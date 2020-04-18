import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
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
  List<RewardTemplate> rewardTemplate = [];
  List<int> purchasedTags = [];
  List<int> purchasedTags2 = [];
  int _numCredits = 0;
  List<int> purchasedDiscounts = [];
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  _RewardsChildState({this.user, this.signOutGoogle, this.path});

  @override
  void initState() {
    super.initState();

    loadTagList();
    var ref = FirebaseDatabase.instance
        .reference()
        .child("rewards/" + path)
        .orderByChild('credits');
    ref.once().then((snapshot) {
      var keys = snapshot.value.keys;
      var data = snapshot.value;

      rewardTemplate.clear();
      int _numCredits = _getCredits();

      for (var individualKeys in keys) {
        RewardTemplate rewTemp = new RewardTemplate(
            data[individualKeys]['name'].toString(),
            data[individualKeys]['credits'],
            Colors.white);

        rewardTemplate.add(rewTemp);
        print(individualKeys);
      }

      rewardTemplate.sort((a, b) => a.credits.compareTo(b.credits));
      setState(() {});
    });
  }

  int _getCredits() {
    //DataSnapshot snapshot1;
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    ref.once().then((snapshot) {
      setState(() {
        _numCredits = snapshot.value['credits'];
      });
    });

    //print ("CREDITS = $_numCredits");

    return _numCredits;
  }

  void loadTagList() async {
    DatabaseReference ref2 = FirebaseDatabase.instance
        .reference()
        .child("users/" + user.uid + "/tags_purchased");

    await ref2.once().then((snapshot) {
      if (snapshot.value != null)
        setState(() {
          purchasedTags2 = new List<int>.from(snapshot.value);
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

    if (_numCredits == null) return;

    if (path == "Tags") {
      DatabaseReference ref2 = FirebaseDatabase.instance
          .reference()
          .child("users/" + user.uid + "/tags_purchased");

      //ref.update({'credits': _numCredits, 'badge': name});

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
          ref.update({'badge': rewardTemplate.name});
          setState(() {
            rewardTemplate.color = Colors.blue;
          });
          _displaySnackbar(context, rewardTemplate.name + ' Tag Applied!');

          print(rewardTemplate.name + "inside");
          return;
        } else {
          purchasedTags.insert(lb, rewardTemplate.credits);
        }

        print("STAGE 2");
        if (_numCredits >= rewardTemplate.credits) {
          _numCredits = _numCredits - rewardTemplate.credits;
          ref.update({'credits': _numCredits, 'badge': rewardTemplate.name});
          setState(() {
            rewardTemplate.color = Colors.blue;
            purchasedTags2 = purchasedTags;
          });
          _displaySnackbar(context, rewardTemplate.name + ' Badge Purchased!');
          ref2.set(purchasedTags);
        } else if (_numCredits < rewardTemplate.credits) {
          print("STAGE 3");
          setState(() {
            rewardTemplate.color = Colors.red;
          });
          _displaySnackbar(context, 'Not sufficient credits!');
        }
      });
    }

    if (path == "Discounts" && rewardTemplate.credits <= _numCredits) {
      print("AWAITING");
      await ref.once().then((snapshot) {
        int discounts = snapshot.value['discounts'] ?? 0;
        _numCredits = _numCredits - rewardTemplate.credits;
        discounts = discounts + int.parse(rewardTemplate.name);
        setState(() {
          rewardTemplate.color = Colors.blue;
        });
        _displaySnackbar(
            context, 'Rs ' + rewardTemplate.name + ' discount Purchased!');
        ref.update({'credits': _numCredits, 'discounts': discounts});
      });
    } else if (path == "Discounts" && rewardTemplate.credits > _numCredits) {
      setState(() {
        rewardTemplate.color = Colors.red;
      });
      _displaySnackbar(context, 'Insufficient Funds!');
    }
  }

  String _getName(RewardTemplate rewardTemplate) {
    String name = rewardTemplate.name.toString();

    if (path == "Discounts") name = "Rs " + name;
    return name;
  }

  bool _hasPurchased(RewardTemplate rewardTemplate) {
    int lb = 0;
    int ub = purchasedTags2.length ?? 0;
    while (lb < ub) {
      int mid = ((lb + ub) / 2).floor();
      if (purchasedTags2[mid].compareTo(rewardTemplate.credits) <= 0)
        lb = mid + 1;
      else
        ub = mid;
    }

    if (lb == 0) return false;
    if (purchasedTags2[lb - 1] == rewardTemplate.credits) {
      return true;
    } else {
      return false;
    }
  }

  Color _getColor(RewardTemplate rewardTemplate) {
    _numCredits = _getCredits();

    if (path == "Tags" && _hasPurchased(rewardTemplate))
      rewardTemplate.color = Colors.blue;
    if (path == "Discounts" && _numCredits < rewardTemplate.credits)
      rewardTemplate.color = Colors.black38;
    if (path == "Discounts" && _numCredits >= rewardTemplate.credits)
      rewardTemplate.color = Colors.white;

    return rewardTemplate.color;
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

  void _displaySnackbar(BuildContext context, String text) {
    final snackbar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.black87),
      ),
      backgroundColor: Theme.of(context).cardColor,
      behavior: SnackBarBehavior.floating,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
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
