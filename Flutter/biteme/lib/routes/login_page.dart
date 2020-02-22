import 'package:biteme/routes/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
                    width: 1.0,
                    color: Theme.of(context).cardColor
                  ),
                ),
                padding: EdgeInsets.all(10),
                color: Theme.of(context).cardColor,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      'https://png2.cleanpng.com/sh/7f1f6723579aca94515cdf5b0a193e97/L0KzQYm3VME6N6lmj5H0aYP2gLBuTfdwd5hxfZ91b3fyPbj2jBdtbV54fdN7Y3iwd7F2hBxmNZJoe9HAboSwgrbrhgMuPZJpUKNvOXTkRbXtUsgvO2g5TaIDMkO0RYO7UcE0O2EATqkEND7zfri=/kisspng-google-logo-google-search-google-account-redes-5ad81f9da5df28.3745082315241133096794.png',
                      scale: 16,
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
