



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/ui/client/client_manager.dart';


import 'package:zoom/ui/login/utils/auth.dart' as auth;
import 'package:zoom/ui/main.dart';
import 'package:zoom/utils/fade_animation_route.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  ClientManager clientManager = ClientManager();

  List<Order_New> orders = [];
  bool loading = true;

  String store;

  void initState() {
    super.initState();

    clientManager.init().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      store = prefs.getString('store');
      print('store: $store');
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
    var snapshot = await Firestore.instance.collection('orders').where('store', isEqualTo: store).getDocuments();
    for(var document in snapshot.documents) {
      String storeID = document['store'];
      Order_New order = Order_New(
        id: document.documentID,
        clientID: document['client'],
        price: document['price'],
      );

      var items = document['items'];
      for(var item in items) {
        var itemID = item.toString().split(':')[0];
        var itemQuantity = int.parse(item.toString().split(':')[1]);
        order.items[itemID] = itemQuantity;
      }

      orders.add(order);
    }
  }

  Future<List<Item>> getItems(Order_New order) async {
    List<Item> tmp = [];
    order.items.forEach((key, value) async{
      var snapshot = await Firestore.instance.collection('stores').document(order.storeID).collection('items').document(key).get();
      var itemData = snapshot.data;
      tmp.add(Item(
        id: snapshot.documentID,
        store: order.storeID,
        description: itemData['desc'],
        category: itemData['category'],
        image: itemData['image'],
        name: itemData['name'],
        price: itemData['price'],
        rating: itemData['rating'],
        stock: itemData['stock'],
      ));
    });
    return tmp;
  }

  Widget orderItem(Order_New order) => ListTile(
    title: Text(order.id),
  );

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
