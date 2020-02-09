
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/components/colors.dart';
import 'package:zoom/ui/client/cart.dart';
import 'package:zoom/ui/client/client_manager.dart';


import 'package:zoom/ui/login/utils/auth.dart' as auth;
import 'package:zoom/ui/main.dart';
import 'package:zoom/ui/store/order_details.dart';
import 'package:zoom/ui/store/store_manager.dart';
import 'package:zoom/ui/store/store_settings.dart';
import 'package:zoom/utils/fade_animation_route.dart';
import 'package:zoom/utils/slide_animation_route.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  ClientManager clientManager = ClientManager();

  List<Order> orders = [];
  bool loading = true;

  StoreManager storeManager;

  void initState() {
    super.initState();

    clientManager.init().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString('store');
      storeManager = StoreManager(id: id);
      await storeManager.init();
      getOrders().then((value) {
        setState(() {
          loading = false;
        });
      }).catchError((error) {
        print(error);
        prefs.setString('state', '');
        Navigator.of(context).push(
            FadeAnimationRoute(
                builder: (context) => MainPage()
            )
        );
      });
    });
  }

  Future<void> getOrders() async {
    orders = [];
    var snapshot = await Firestore.instance.collection('orders').where('store', isEqualTo: storeManager.id).getDocuments();
    for(var document in snapshot.documents) {
      String storeID = document['store'];
      Order order = Order(
        storeID: storeID,
        id: document.documentID,
        clientID: document['client'],
        clientName: document['name'],
        price: document['price'],
      );

      var items = document['items'];
      print(items);
      for(var item in items) {
        var itemID = item.toString().split(':')[0];
        var itemQuantity = int.parse(item.toString().split(':')[1]);
        order.items[itemID] = itemQuantity;
      }

      orders.add(order);
    }
  }

  Widget statusIcon(Order order) {
    switch(order.status) {
      case ORDER_STATUS.PENDING:
        return IconButton(
          icon: Icon(
            Icons.check,
          ),
          onPressed: () {
            setState(() {
              order.status = ORDER_STATUS.CONFIRMED;
            });
          },
        );
      case ORDER_STATUS.CONFIRMED:
        return IconButton(
          icon: Icon(
            Icons.send,
            color: primaryColor,
          ),
          onPressed: () {
            setState(() {
              order.status = ORDER_STATUS.IN_TRANSIT;
            });
          },
        );
      case ORDER_STATUS.IN_TRANSIT:
        return IconButton(
          icon: Icon(
            Icons.local_shipping,
            color: secondaryColor,
          ),
        );
      case ORDER_STATUS.DELIVERED:
        return IconButton(
          icon: Icon(
            Icons.local_shipping,
            color: Colors.green,
          ),
        );
      case ORDER_STATUS.CANCELLED:
        return IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
        );
      default:
        return Container();
    }
  }

  Widget orderItem(Order order) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );
    return ListTile(
      title: Text(order.clientName),
      subtitle: Text(order.id),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(formatter.format(order.price)),
          statusIcon(order),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(SlideAnimationRoute(
          page: OrderDetailsPage(order),
          offset: Offset(0, 1),
          curve: Curves.decelerate,
        ));
      },
    );
  }

  List<Widget> ordersList() => orders.map((e) => orderItem(e)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading ? SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              loading = true;
            });
            clientManager.init().then((value) {
              getOrders().then((value) {
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
                    trailing: IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.of(context).push(FadeAnimationRoute(
                          builder: (context) => StoreSettings(storeManager)
                        )).then((value) {
                          setState(() {
                          });
                        });
                      },
                    ),
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
                        text: 'Orders for ${storeManager.store.name}:'
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                   ordersList()
                ),
              ),
            ],
          ),
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}
