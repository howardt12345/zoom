


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  FirebaseMessaging _fcm = new FirebaseMessaging();


  void initState() {
    super.initState();
  }

  Future<PageState> getPageState() async {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if(firebaseUser != null) {
        user = firebaseUser;
      } else {
        print('No user');
      }
    });

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    }

    _fcm.getToken().then((token) {
      Firestore.instance.collection('orders').document('0').setData({
        'token': token
      });
      print(token);
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );

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

