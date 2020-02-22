import 'dart:math';

import 'package:biteme/routes/home_page.dart';
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
  bool logOut;

  _LoginPageState({this.logOut}) {
    googleSignIn = GoogleSignIn();

    logOutUser(this.logOut).then((value) {});

    isLoggedIn().then((value) {
      if (value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(
                  user: user,
                  googleSignIn: googleSignIn,
                )));
      }
    });
  }

  logOutUser(bool logOut) async{
    if(logOut)
      await _auth.signOut();
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
    return 'signInWithGoogle succeeded: $user';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(25),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(50),
              child: RaisedButton(
                elevation: 7,
                shape: StadiumBorder(
                  side: BorderSide(
                      width: 1.0, color: Theme.of(context).cardColor),
                ),
                padding: EdgeInsets.all(10),
                color: Theme.of(context).cardColor,
                onPressed: () {
                  signInWithGoogle().whenComplete(() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
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
                    Image.network(
                      'https://png2.cleanpng.com/sh/7f1f6723579aca94515cdf5b0a193e97/L0KzQYm3VME6N6lmj5H0aYP2gLBuTfdwd5hxfZ91b3fyPbj2jBdtbV54fdN7Y3iwd7F2hBxmNZJoe9HAboSwgrbrhgMuPZJpUKNvOXTkRbXtUsgvO2g5TaIDMkO0RYO7UcE0O2EATqkEND7zfri=/kisspng-google-logo-google-search-google-account-redes-5ad81f9da5df28.3745082315241133096794.png',
                      scale: 15,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blueGrey[200],
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
