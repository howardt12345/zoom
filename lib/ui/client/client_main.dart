

import 'package:flutter/material.dart';

import 'package:zoom/ui/login/utils/auth.dart' as auth;
import 'package:zoom/utils/fade_animation_route.dart';

import '../main.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(

              leading: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  auth.signOut();
                  Navigator.of(context).push(FadeAnimationRoute(builder: (context) => MainPage()));
                },
              ),
              title: Text("Hi, !"),
            )
          ],
        ),
      ),
    );
  }
}
