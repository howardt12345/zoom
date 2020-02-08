

import 'package:flutter/material.dart';

import 'package:zoom/ui/login/utils/auth.dart' as auth;

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
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
