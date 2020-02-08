

import 'package:flutter/material.dart';

import 'package:zoom/ui/login/utils/auth.dart' as auth;

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
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
