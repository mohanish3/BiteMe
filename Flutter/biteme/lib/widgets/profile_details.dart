import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileDetails extends StatefulWidget {
  final FirebaseUser user;

  ProfileDetails({this.user});

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState(user: user);
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final FirebaseUser user;

  _ProfileDetailsState({this.user});

  @override
  Widget build(BuildContext context) {
    return  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(100, 20, 100, 20),
                child: ClipOval(
                  child: Image.network(
                    user.photoUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                  child: Text(
                user.displayName,
                style: TextStyle(fontSize: 25),
              )),
            ],
          );
  }
}
