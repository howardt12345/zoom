import 'package:flutter/material.dart';
import 'package:zoom/components/classes.dart';

import 'package:zoom/ui/login/utils/auth.dart' as auth;
import 'package:zoom/ui/store/order.dart';
import 'package:zoom/ui/store/store_manager.dart';
import 'package:zoom/utils/fade_animation_route.dart';

import '../main.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  StoreManager storeManager = new StoreManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Demo Store'),
          leading: IconButton(
            icon: Icon(Icons.store),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
              ),
              ListTile(
                leading: Icon(Icons.search),
                title: Text("Search"),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Logout"),
                onTap: () {
                  auth.signOut();
                  Navigator.of(context).push(
                      FadeAnimationRoute(builder: (context) => MainPage()));
                },
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          child: ListView.builder(
            itemBuilder: _buildOrdersList,
            itemCount: storeManager.orders.length,
          ),
        ));
  }

  Widget _buildOrdersList(BuildContext context, int index) {
    Order order = storeManager.orders[index];
    return Card(
      margin: EdgeInsets.all(6),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(FadeAnimationRoute(builder: (context) => OrderPage(order: order)));
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16),
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(order.client.name),
                    SizedBox(height: 10.0),
                    Text(order.id),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("\$${order.price.toString()}"),
                    SizedBox(height: 10.0),
                    Text(order.items.length.toString()),
                  ],
                )
              ],
            )
        ),
      ),
    );
  }
}
