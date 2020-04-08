import 'package:biteme/tabs/home/rewards_page.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/routes/bookmark_page.dart';
import 'package:biteme/routes/bar_pages.dart';
import 'package:biteme/routes/home_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:biteme/utilities/server_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:biteme/utilities/firebase_functions.dart';

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

  String _status = "Loading";
  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";
  String _numCredits = "Loading";
  String _numReviews = "Loading";
  String _numBooks = "Loading";

  //static var userid = user;
  _ProfileDetailsState({this.user, this.signOutGoogle}) {
    //_getRevs();
    //_getBookmarks();
    //_getCredits();
  }

  String _getReviews() {
    //DataSnapshot snapshot1;
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("users/" + user.uid + "/history/reviewedProducts");
    ref.once().then((snapshot) {
      setState(() {
        _numReviews = snapshot.value.length.toString();
      });
    });

    return _numReviews;
  }

  String _getBookmarks() {
    //DataSnapshot snapshot1;
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("users/" + user.uid + "/history/bookmarks");
    ref.once().then((snapshot) {
      setState(() {
        _numBooks = snapshot.value.length.toString();
      });
    });

    return _numBooks;
  }

  String _getCredits() {
    //DataSnapshot snapshot1;
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    ref.once().then((snapshot) {
      setState(() {
        _numCredits = snapshot.value['credits'].toString();
      });
    });

    return _numCredits;
  }

  String _getStatus() {
    //DataSnapshot snapshot1;
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    ref.once().then((snapshot) {
      setState(() {
        _status = snapshot.value['badge'].toString();
      });
    });

    return _status;
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/BITS_Logo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        print("hellosamurai");
      },
      child: Center(
        child: Container(
          width: 140.0,
          height: 140.0,
          child: ClipOval(
            child: FadeInImage.assetNetwork(
              fadeInCurve: Curves.fastOutSlowIn,
              placeholder: 'assets/images/product_placeholder.png',
              image: user.photoUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return GestureDetector(
      onTap: () {
        print("hellosamurai");
      },
      child: Text(
        user.displayName,
        style: _nameTextStyle,
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _getStatus(),
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    //int abc = (_getNumReviews() as int);

    //_getRevs();

    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            child: _buildStatItem("Reviews", _getReviews()),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ReviewHelpPage(),
            )),
          ),
          FlatButton(
            child: _buildStatItem("Bookmarks", _getBookmarks()),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BookmarkPage(user: user),
            )),
          ),
          FlatButton(
            child: _buildStatItem("Credits", _getCredits()),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreditsHelpPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return GestureDetector(
      onTap: () {
        print("hellosamurai");
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.all(8.0),
        child: Text(
          _bio,
          textAlign: TextAlign.center,
          style: bioTextStyle,
        ),
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: signOutGoogle,
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "SIGN OUT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ContactPage(),),
              ),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "CONTACT US",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signOutBar() {
    return CustomAppBar(icons: <Widget>[
      Container(),
      CustomIconButton(
        icon: Icons.exit_to_app,
        onPressed: signOutGoogle,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 10.0),
                  _buildProfileImage(),
                  _buildFullName(),
                  _buildStatus(context),
                  _buildStatContainer(),
                  _buildBio(context),
                  _buildSeparator(screenSize),
                  SizedBox(height: 10.0),
                  SizedBox(height: 8.0),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
