import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  CustomIconButton({this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        child: RawMaterialButton(
          shape: CircleBorder(),
          child: Icon(icon, color: Theme.of(context).iconTheme.color),
          fillColor: Theme.of(context).buttonColor,
          elevation: 7,
          onPressed: onPressed,
        ));
  }
}
