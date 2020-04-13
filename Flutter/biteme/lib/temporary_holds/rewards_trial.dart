import 'package:biteme/widgets/custom_app_bar.dart';

import 'package:biteme/temporary_holds/working_rewards_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:biteme/utilities/server_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:biteme/utilities/firebase_functions.dart';

class RewardTemplate{
  String id;
  String name;
  int credits;

  RewardTemplate({this.id, this.name, this.credits});

  Map<String, dynamic> toJson() => {
        'name': name,
        'credits': credits
      };

      RewardTemplate.fromJson(Map<dynamic, dynamic> json)
      : id = json['key'],
        name = json['value']['name'],
        credits = json['value']['credits'];
}

class RewardCard extends StatefulWidget {
  final RewardTemplate reward;

  RewardCard({this.reward});

  @override
  _RewardCardState createState() => _RewardCardState(reward: reward);
}

class _RewardCardState extends State<RewardCard> {
  Map<String, dynamic> rewardData;
  FirebaseUser user;
  final RewardTemplate reward;
  bool isLiked;

  _RewardCardState({this.reward}) {
    isLiked = false;
    rewardData = reward.toJson();
  }

  Future<FirebaseUser> getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<FirebaseUser>(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container();
          else {
            
            return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    EdgeInsets.only(left: 12, right: 10, top: 10, bottom: 10),
                child: Column(children: <Widget>[
                  
                      Flexible(
                          child: Container(
                        child: Text(
                          reward.name,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      )),
                      
                  
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        (reward.credits.toString() + " Credits") ,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300),
                      )),
                 /* Container(
                    padding: EdgeInsets.only(top: 5, left: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                review.authorName,
                                style: TextStyle(
                                    fontSize: 13, fontStyle: FontStyle.italic),
                              ),
                              Text(
                                  review.likes.length.toString() +
                                      ' people like this.',
                                  style: TextStyle(fontSize: 13)),
                            ]),
                        Container(
                            width: 35,
                            height: 35,
                            margin: EdgeInsets.only(right: 2),
                            alignment: Alignment.center,
                            child: user.uid == review.authorId
                                ? Container()
                                : FlatButton(
                                    padding: EdgeInsets.all(0),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: isLiked
                                        ? Icon(
                                            Icons.thumb_up,
                                            color: Colors.green,
                                            size: 25,
                                          )
                                        : Icon(
                                            Icons.thumb_up,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                    onPressed: () {
                                      if (isLiked) {
                                        setState(() {
                                          review.unlikeReview(
                                              user.uid, widget.productId);
                                          isLiked = false;
                                        });
                                      } else {
                                        setState(() {
                                          review.likeReview(
                                              user.uid, widget.productId);
                                          isLiked = true;
                                        });
                                      }
                                    },
                                  ))
                      ],
                    ),
                  )0*/
                ]));
          }
        });
  }
}


class RewardList extends StatelessWidget{
  final BuildContext context;
  List<RewardTemplate> rewardTemplate;

  RewardList({this.context, this.rewardTemplate}) {
    if (rewardTemplate == null) rewardTemplate = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      child: rewardTemplate.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No rewards yet!',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                ),
              ],
            )
          : ListView.builder(
              itemCount: rewardTemplate.length,
              itemBuilder: (context, index) {
                return RewardCard(reward: rewardTemplate[index],);
              }),
    );
  }
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


   /*@override
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
        print ("Length ");
      });
    });
  } */

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
    
    return SafeArea(
        child: Container(
            child: Column(children: <Widget>[
      CustomAppBar(
        icons: <Widget>[
          Text(
            "Rewards",
            style: TextStyle(
                fontSize: 35,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: FirebaseFunctions.getTraversedChild(
                    ['rewards', 'tags']).onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else {
                    List<RewardTemplate> _rewardsList = [];
                    Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
                    if (values != null)
                      values.forEach((key, value) {
                        _rewardsList
                            .add(RewardTemplate.fromJson({'key': key, 'value': value}));
                      });
                    return RewardList(
                      context: context,
                      rewardTemplate : _rewardsList,
                    );
                  }
                }
                )
          ],
        ),
      ),
    ])));
}

}