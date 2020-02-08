

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom/ui/client/clientmain.dart';
import 'package:zoom/ui/login/loginmain.dart';
import 'package:zoom/ui/store/storemain.dart';

import 'driver/drivermain.dart';

enum PageState {
  Client,
  Driver,
  Store,
  none,
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageState _pageState;

  void initState() {
    super.initState();
  }

  Future<PageState> getPageState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String state = prefs.getString("state") ?? '';
    switch(state) {
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
        if (snapshot.hasData) {
          switch(snapshot.data) {
            case PageState.Client:
              return ClientPage();
            case PageState.Driver:
              return DriverPage();
            case PageState.Store:
              return StorePage();
            case PageState.none:
            default:
              return LoginPage();
          }
        } else {
          return Center(
            child: Text("help plz there is error oh no"),
          );
        }
      },
    );
  }
}

