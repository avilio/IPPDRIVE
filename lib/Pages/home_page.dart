import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
          child: new Image.asset("images/icon.png", 
          fit: BoxFit.contain,)
    );
  }
}
