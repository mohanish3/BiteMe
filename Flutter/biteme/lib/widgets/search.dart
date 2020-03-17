import 'package:biteme/widgets/customiconbutton.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  SearchTab({this.scaffoldKey});

  _SearchTabState createState() => _SearchTabState(scaffoldKey: scaffoldKey);
}

class _SearchTabState extends State<SearchTab> {
  final GlobalKey<ScaffoldState> scaffoldKey;

  _SearchTabState({this.scaffoldKey});

  void _displaySnackbar(BuildContext context, String text) {
    final snackbar = SnackBar(content: Text(text));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(15),
        alignment: Alignment.topCenter,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                child: TextField(
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products...",
                    hintStyle: TextStyle(fontSize: 20),
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                  ),
                ),
              ),
            ),
            CustomIconButton(
              icon: Icons.search,
              onPressed: () => _displaySnackbar(context, "TODO!"),
            )
          ],
        ),
      ),
    );
  }
}
