import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final List<Widget> icons;

  CustomAppBar({this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: icons),
    );
  }
}
