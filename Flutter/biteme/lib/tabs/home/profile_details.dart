import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileDetails extends StatefulWidget {
  final FirebaseUser user;
  final Function signOutGoogle;

  ProfileDetails({this.user, this.signOutGoogle});

  @override
  _ProfileDetailsState createState() =>
      _ProfileDetailsState(user: user, signOutGoogle: signOutGoogle);
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final FirebaseUser user;
  final Function signOutGoogle;

  _ProfileDetailsState({this.user, this.signOutGoogle});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(children: <Widget>[
          CustomAppBar(icons: <Widget>[
            Container(),
            CustomIconButton(icon: Icons.exit_to_app, onPressed: signOutGoogle,)
          ]),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(100, 20, 100, 20),
            child: ClipOval(
              child: FadeInImage.assetNetwork(
                fadeInCurve: Curves.fastOutSlowIn,
                placeholder: 'assets/images/product_placeholder.png',
                image: user.photoUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),

                ),
                padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    Center(
                        child: Text(
                      user.displayName,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400, fontFamily: 'OpenSans'),
                    )),

                  ],
                ),
              ))
        ]),
      ),
    );
  }
}
