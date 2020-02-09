

import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/components/colors.dart';
import 'package:zoom/ui/address/select_address.dart';
import 'package:zoom/ui/client/category_icon_bar.dart';
import 'package:zoom/ui/client/client_manager.dart';
import 'package:zoom/ui/client/listings_manager.dart';
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
  ClientManager clientManager = ClientManager();
  ListingsManager listingsManager = ListingsManager();
  String address;

  void initState() {
    super.initState();
    clientManager.init().then((value) {
      listingsManager.init().then((value) {
        setState(() {
          loading = false;
        });
      });
    });
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
    await this.clientManager.addAddress(result);
    setState(() {
      this.loading = false;
    });
  }

  selectAddressButton() => FlatButton(
    onPressed: () => Navigator.of(context).push(
        FadeAnimationRoute(
            builder: (context) => SelectAddressPage(manager: clientManager,)
        )
    ).then((value) {
      setState(() {});
      return null;
    }),
    child: Text(
      clientManager.client.defaultAddress == null ? "ADD ADDRESS" : clientManager.client.defaultAddress.split(',')[0],
      style: Theme.of(context).textTheme.button.copyWith(
          fontSize: 12,
          color: secondaryColor
      ),
    ),
  );

  List<Widget> storesList() => listingsManager.stores.map<Widget>((e) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print("a");
            },
            child: Container(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: e.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  e.name,
                  style: Theme.of(context).textTheme.title,
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  )).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !loading ? Stack(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  loading = true;
                });
                clientManager.init().then((value) {
                  listingsManager.init().then((value) {
                    setState(() {
                      loading = false;
                    });
                  });
                });
              },
              child: CustomScrollView(
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
                        child: clientManager.client.photoUrl == null ? new Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 35.0,
                        ) : CircleAvatar(
                          backgroundImage: NetworkImage(clientManager.client.photoUrl),
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
                              text: 'Hi, ${clientManager.name.split(" ")[0]}!'
                          ),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Text("Deliver to: "),
                            selectAddressButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      height: 64,
                      child: CategoryIconBar(
                        onIndexChange: (index) => print(index),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                            style: Theme.of(context).textTheme.body1.copyWith(
                                fontSize: 20.0
                            ),
                            text: 'Stores Near You:'
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                        storesList()
                    ),
                  ),
                ],
              ),
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
                  badgeContent: Text('${clientManager.length}'),
                  child: IconButton(
                    iconSize: 30.0,
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () => Navigator.of(context).push(
                      SlideAnimationRoute(
                        page: ShoppingCart(manager: clientManager,),
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
