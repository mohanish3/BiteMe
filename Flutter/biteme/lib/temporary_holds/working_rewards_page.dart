import 'package:firebase_auth/firebase_auth.dart';
import 'package:biteme/utilities/server_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:biteme/utilities/firebase_functions.dart';

class RewardTemplate{
  String name;
  int credits;

  RewardTemplate(this.name, this.credits);
}


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

_RewardsState({this.user, this.signOutGoogle});

  List<RewardTemplate> rewardTemplate = [];


   @override
   void initState() {
    super.initState();

    DatabaseReference ref = FirebaseDatabase.instance.reference().child("rewards/tags");
    ref.once().then((snapshot) {

      var keys = snapshot.value.keys;
      var data = snapshot.value;

      rewardTemplate.clear();

      for (var individualKeys in keys){
        RewardTemplate rewTemp = new RewardTemplate(
          data[individualKeys]['name'],
          data[individualKeys]['credits']
        );

        rewardTemplate.add(rewTemp);
      }

      setState(() {
        //print ("Length = $rewTemp.length");
      });
    });
  }

  Widget RewUI (String name, int credits) {
      return new Card(
        elevation : 10.0,
        margin: EdgeInsets.all(15.0),

        child : new Container (
          padding : new EdgeInsets.all(10.0),

          child : new Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              new Text(
                name,
                style: Theme.of(context).textTheme.subtitle,
                textAlign: TextAlign.center,
              ),

              new Text(
                credits.toString(),
                style: Theme.of(context).textTheme.subtitle,
                textAlign: TextAlign.center,
              ),
            ]
          )
        )
      );
      
}

   @override
  Widget build(BuildContext context) {
    
    return new Scaffold (
      appBar : new AppBar (
        title : new Text ("TEST"),
      ),

      body: new Container(
        child: rewardTemplate.length == 0
        ? new Text ("No Rewards Available, sorry.")
        : new ListView.builder (
          itemCount : rewardTemplate.length,
          itemBuilder : (_, index) {
            return RewUI (rewardTemplate[index].name, rewardTemplate[index].credits);
          }
        ) 

      )
    );
  }

}

