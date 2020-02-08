


import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zoom/ui/client/client_main.dart';
import 'package:zoom/ui/driver/driver_main.dart';
import 'package:zoom/ui/login/login_main.dart';
import 'package:zoom/ui/login/state_select.dart';
import 'package:zoom/ui/store/store_main.dart';

enum PageState {
  Client,
  Driver,
  Store,
  none,
}

FirebaseUser user;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void initState() {
    super.initState();
  }

  Future<PageState> getPageState() async {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if(firebaseUser != null) {
        user = firebaseUser;
        print(user.displayName);
      } else {
        print('No user');
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String state = prefs.getString("state") ?? '';
    switch(state.toLowerCase()) {
      case "client":
        return PageState.Client;
      case "driver":
        return PageState.Driver;
      case "store":
        return PageState.Store;
      default:
        return PageState.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPageState(),
      initialData: PageState.none,
      builder: (context, snapshot) {
        if (snapshot.hasData && user != null) {
          switch(snapshot.data) {
            case PageState.Client:
              return ClientPage();
            case PageState.Driver:
              return DriverPage();
            case PageState.Store:
              return StorePage();
            case PageState.none:
              return StateSelectPage();
            default:
              return LoginPage(nextPage: StateSelectPage(),);
          }
        } else {
          return LoginPage(nextPage: StateSelectPage(),);
        }
      },
    );
  }
}

