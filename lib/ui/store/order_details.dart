


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/ui/client/cart.dart';
import 'package:zoom/ui/client/shopping_cart.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;

  OrderDetailsPage(this.order);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  bool loading = true;

  Cart cart;

  void initState() {
    super.initState();
    getItems(widget.order).then((value) {
      setState(() {
        this.cart = value;
        this.loading = false;
      });
    });
  }

  Future<Cart> getItems(Order order) async {
    Cart tmp = Cart(null, null);

    await Future.forEach(order.items.keys, (key) async {
      var snapshot = await Firestore.instance.collection('stores').document(order.storeID).collection('items').document(key).get();
      var itemData = snapshot.data;
      tmp.addProductToCart(Item(
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

  List<Widget> _createShoppingCartRows() {
    return cart.keys.map<Widget>((String id) => ShoppingCartRow(
      item: cart.getItem(id),
      quantity: cart.cart[id],
      onRemove: null,
    ),).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading ? CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(78.0),
              child: ListTile(
                title: RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.body1.copyWith(
                          fontSize: 32.0
                      ),
                      text: 'Order Details:'
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(widget.order.clientName),
                  subtitle: Text(widget.order.id),
                ),
                ListTile(
                  title: Text("Items: "),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: _createShoppingCartRows(),
            ),
          ),
        ],
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}
