

import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/components/colors.dart';
import 'package:zoom/ui/client/client_manager.dart';
import 'package:zoom/ui/client/shopping_cart.dart';

import 'package:zoom/ui/login/utils/auth.dart' as auth;
import 'package:zoom/utils/fade_animation_route.dart';
import 'package:zoom/utils/slide_animation_route.dart';

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
    manager.init().then((value) => setState(() {
      loading = false;
      manager.addProductToCart(Item(
        id: "1",
        description: "This is a demo item",
        image: "https://picsum.photos/250?image=9",
        name: "Demo Item 1",
        price: 19.95,
        rating: 4.15,
      ));
      manager.addProductToCart(Item(
        id: "2",
        description: "This is a demo item",
        image: "https://picsum.photos/250?image=9",
        name: "Demo Item 2",
        price: 19.95,
        rating: 4.15,
      ));
      manager.addProductToCart(Item(
        id: "3",
        description: "This is a demo item",
        image: "https://picsum.photos/250?image=9",
        name: "Demo Item 3",
        price: 19.95,
        rating: 4.15,
        stock: 5,
      ));
      manager.addProductToCart(Item(
        id: "3",
        description: "This is a demo item",
        image: "https://picsum.photos/250?image=9",
        name: "Demo Item 3",
        price: 19.95,
        rating: 4.15,
        stock: 5,
      ));
      manager.addProductToCart(Item(
        id: "3",
        description: "This is a demo item",
        image: "https://picsum.photos/250?image=9",
        name: "Demo Item 3",
        price: 19.95,
        rating: 4.15,
        stock: 5,
      ));
      manager.addProductToCart(Item(
        id: "4",
        description: "This is a demo item",
        image: "https://picsum.photos/250?image=9",
        name: "Demo Item 4",
        price: 19.95,
        rating: 4.15,
      ));
      manager.addProductToCart(Item(
        id: "5",
        description: "This is a demo item",
        image: "https://picsum.photos/250?image=9",
        name: "Demo Item 5",
        price: 19.95,
        rating: 4.15,
      ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !loading ? Stack(
          children: <Widget>[
            Container(
              child: Text(manager.name),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: new BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                  )
                ),
                padding: EdgeInsets.all(8.0),
                child: Badge(
                  badgeColor: primaryColor,
                  position: BadgePosition.topRight(top: 0, right: 3),
                  badgeContent: Text('${manager.length}'),
                  child: IconButton(
                    iconSize: 30.0,
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () => Navigator.of(context).push(
                      SlideAnimationRoute(
                        page: ShoppingCart(manager: manager,),
                        offset: Offset(0, 1),
                        curve: Curves.decelerate,
                      )
                    ),
                  ),
                ),
              ),
            ),
          ],
        ) : Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
