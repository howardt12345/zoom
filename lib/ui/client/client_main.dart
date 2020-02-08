

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zoom/ui/client/client_manager.dart';

import 'package:zoom/ui/login/utils/auth.dart' as auth;
import 'package:zoom/utils/fade_animation_route.dart';

import '../main.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  bool loading = true;
  ClientManager manager = ClientManager();

  void initState() {
    super.initState();
    manager.init().then((value) => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !loading ? Container(
          child: Text(manager.name),
        ) : Center(child: CircularProgressIndicator(),),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),

            )
          ],
        ),
      ),
    );
  }
}
