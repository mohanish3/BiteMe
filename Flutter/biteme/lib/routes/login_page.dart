import 'dart:math';

import 'package:biteme/routes/home_page.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  bool logOut = false;

  LoginPage({this.logOut});

  @override
  _LoginPageState createState() => _LoginPageState(logOut: logOut);
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn;
  FirebaseUser user;
  bool showSignIn;

  _LoginPageState({logOut}) {
    googleSignIn = GoogleSignIn();

    showSignIn = false;

    logOutUser(logOut).then((value) {});

    isLoggedIn().then((value) {
      if (value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(
                  user: user,
                  googleSignIn: googleSignIn,
                )));
      } else
        setState(() {
          showSignIn = true;
        });
    });
  }

  logOutUser(bool logOut) async {
    if (logOut) await _auth.signOut();
  }

  Future<bool> isLoggedIn() async {
    user = await _auth.currentUser();
    if (user != null) {
      IdTokenResult tokenResult = await user.getIdToken(refresh: true);
      return tokenResult.token != null;
    } else {
      return false;
    }
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    this.user = user;

    FirebaseUserMetadata metaData = currentUser.metadata;
    if(metaData.creationTime == metaData.lastSignInTime) {
      DatabaseReference ref = FirebaseFunctions.getTraversedChild(['users', user.uid]);
      ref.set({
        'reviews': [],
        'credits': 0,
        'activity': {}
      });
    }

    return 'signInWithGoogle succeeded: $user';
  }

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
              child: showSignIn
                  ? RaisedButton(
                      elevation: 7,
                      shape: StadiumBorder(
                        side: BorderSide(
                            width: 1.0, color: Theme.of(context).cardColor),
                      ),
                      padding: EdgeInsets.all(10),
                      color: Theme.of(context).cardColor,
                      onPressed: () {
                        signInWithGoogle().whenComplete(() {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        user: user,
                                        googleSignIn: googleSignIn,
                                      )));
                        });
                      },
                      child: Row(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/google_logo.png',
                            width: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Login with Google',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
