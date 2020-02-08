

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum PageState {
  Client,
  Driver,
  Store,
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

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

