import 'package:biteme/routes/bookmark_page.dart';
import 'package:biteme/routes/bar_pages.dart';
import 'package:biteme/routes/home_page.dart';
import 'package:biteme/routes/upload_photo.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class ProfileDetails extends StatefulWidget {
  final FirebaseUser user;
  final Function signOutGoogle;

  ProfileDetails({this.user, this.signOutGoogle});

  @override
  _ProfileDetailsState createState() =>
      _ProfileDetailsState(user: user, signOutGoogle: signOutGoogle);
}

class _ProfileDetailsState extends State<ProfileDetails> {
  FirebaseUser user;
  final Function signOutGoogle;

  String _status = "Loading...";
  final String _bio =
      "To modify any of your details, please tap on the respective field.\nHave a great time using BiteME!";
  String _numCredits = "0";
  String _numReviews = "0";
  String fullName = "Loading...";
  String imageUrl = "https://images.unsplash.com/photo-1555445091-5a8b655e8a4a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80";
  GoogleSignIn googleSignIn = GoogleSignIn();
  var titleController = TextEditingController();


  _ProfileDetailsState({this.user, this.signOutGoogle});

  String _getReviews() {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("users/" + user.uid + "/history/reviewedProducts");
    ref.once().then((snapshot) {
      setState(() {
        _numReviews = snapshot.value.length.toString() ?? "0";
      });
    });

    return _numReviews;
  }

  String _getCredits() {
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    ref.once().then((DataSnapshot snapshot) {
      setState(() {
        _numCredits = snapshot.value['credits'].toString();
      });
    });

    return _numCredits;
  }

  String _numDiscounts = "Loading...";

  String _getDiscounts() {
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    ref.once().then((snapshot) {
      setState(() {
        _numDiscounts = snapshot.value['discounts'].toString();
      });
    });

    return _numDiscounts;
  }

  String _getStatus() {
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    ref.once().then((snapshot) {
      setState(() {
        _status = snapshot.value['badge'].toString();
      });
    });

    return _status;
  }

  String _getProfilePhoto() {
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    ref.once().then((snapshot) {
      setState(() {
        imageUrl = snapshot.value['photoUrl'].toString();
      });
    });
    if (imageUrl == null) imageUrl = "https://cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png?format=jpg&quality=90&v=1530129081";
    return imageUrl;
  }

   String _getName() {
    
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/" + user.uid);
    ref.once().then((snapshot) {
      setState(() {
        fullName = snapshot.value['name'];
      });
    });

    return fullName;
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ImageCapture(),
            )),
      child: Center(
        child: Container(
          width: 140.0,
          height: 140.0,
          child: ClipOval(
              child: FadeInImage.assetNetwork(
              fadeInCurve: Curves.fastOutSlowIn,
              placeholder: 'assets/images/product_placeholder.png',
              image: _getProfilePhoto() ?? 'cdn.shopify.com/s/files/1/0533/2089/files/placeholder-images-image_large.png?format=webp&v=1530129081',
              fit: BoxFit.fill,),
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    bool textOrField = true;

    return GestureDetector(
      onTap: () {
        setState(() {
          textOrField? textOrField = false : textOrField = true;
        });
        
        print ("Hello Samurai" + textOrField.toString());
      },
      child: textOrField? Text(
        _getName() ?? "Loading...",
        style: _nameTextStyle,
      )
      : Text ("WORKS"),
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
          fontFamily: 'OpenSans',
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
            child: _buildStatItem("Discounts", _getDiscounts()),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BookmarkPage(user: user),
            )),
          ),
          FlatButton(
            child: _buildStatItem("Credits", _getCredits()),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomePage(
                  user: user,
                  googleSignIn: googleSignIn,
                  selectedIndex: 3,
                ),
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
      fontWeight: FontWeight.w400, 
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    //print (user.photoUrl + ".....................");
    //user.reload();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //_buildCoverImage(screenSize),
         
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 13),
                  _buildProfileImage(),
                  SizedBox(height: 15.0,),
                  _buildFullName(),
                  _buildStatus(context),
                  SizedBox(height: 5.0,),
                  _buildStatContainer(),
                  SizedBox(height: 5.0,),
                  _buildBio(context),
                  SizedBox(height: 5.0,),
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
