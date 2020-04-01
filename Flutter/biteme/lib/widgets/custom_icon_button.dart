import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final Color color;

  CustomIconButton({this.icon, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        child: RawMaterialButton(
          shape: CircleBorder(),
          child: color == null
              ? Icon(icon, color: Theme.of(context).iconTheme.color)
              : Icon(icon, color: color),
          fillColor: Theme.of(context).buttonColor,
          elevation: 7,
          onPressed: onPressed,
        ));
  }
}
