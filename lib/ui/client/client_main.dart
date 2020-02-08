

import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/components/colors.dart';
import 'package:zoom/ui/address/select_address.dart';
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
  String address;

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

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlacePicker("AIzaSyCK4H4ZX6D7dtE0l59iCksJt9Im-myHoQ4",)
      )
    );
    // Handle the result in your way
    setState(() {
      this.loading = true;
    });
    await this.manager.addAddress(result);
    setState(() {
      this.loading = false;
    });
  }

  addAddressButton() => FlatButton(
    onPressed: () => Navigator.of(context).push(FadeAnimationRoute(builder: (context) => SelectAddressPage(manager: manager,))),
    child: Text(
      "ADD ADDRESS",
      style: Theme.of(context).textTheme.button.copyWith(
          fontSize: 12,
          color: secondaryColor
      ),
    ),
  );

  dropdownButton() => DropdownButton<String>(
    value: manager.client.addressesAsString()[0],
    style: TextStyle(
        color: secondaryColor
    ),
    onChanged: (String newValue) {
      setState(() {
        address = newValue;
      });
    },
    items: manager.client.addressesAsString().map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !loading ? Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  leading: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new RawMaterialButton(
                      onPressed: () async {
                        await auth.signOut();
                        Navigator.of(context).push(
                            FadeAnimationRoute(
                                builder: (context) => MainPage()
                            )
                        );
                      },
                      child: manager.client.photoUrl == null ? new Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 35.0,
                      ) : CircleAvatar(
                        backgroundImage: NetworkImage(manager.client.photoUrl),
                      ),
                      shape: new CircleBorder(),
                      elevation: 0.0,
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                    )
                  ],
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(112.0),
                    child: ListTile(
                      title: RichText(
                        text: TextSpan(
                            style: Theme.of(context).textTheme.body1.copyWith(
                                fontSize: 32.0
                            ),
                            text: 'Hi, ${manager.name.split(" ")[0]}!'
                        ),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text("Deliver to: "),
                          manager.addresses.length > 10
                          ? Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                dropdownButton(),
                              ],
                            ),
                          ) : addAddressButton()
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((_, i) {
                    return ListTile(title: Text("Item ${i}"));
                  }, childCount: 20),
                ),
              ],
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
