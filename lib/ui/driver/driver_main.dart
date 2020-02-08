

import 'package:flutter/material.dart';

import 'package:zoom/ui/login/utils/auth.dart' as auth;

class DriverPage extends StatefulWidget {
  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FlatButton(
            child: Text("Sign Out"),
            onPressed: () {
              auth.signOut();
            },
          ),
        ),
      ),
    );
  }
}
