import 'package:flutter/material.dart';
import 'package:zoom/components/classes.dart';

class OrderPage extends StatefulWidget {
  Order order;
  OrderPage({this.order});
  @override
  _OrderPageState createState() => _OrderPageState(order);
}

class _OrderPageState extends State<OrderPage> {
  Order order;
  _OrderPageState(Order order) {
    this.order = order;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.shopping_cart)
              ),
              Tab(
                icon:Icon(Icons.person)
              ),
              Tab(
                icon: Icon(Icons.settings)
              ),
            ],
          ),
          title: Text("Order ${order.id} for ${order.client.name.split(" ")[0]}"),
        ),
        body: (
          TabBarView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                    itemBuilder: _itemListBuilder,
                    itemCount: order.items.length,
                ),
              ),
              Container(
                child: Text("TODO"),
              ),
              Container(
               child: Text("TODO"),
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget _itemListBuilder(BuildContext context, int index) {
    Item item = order.items[index];
    return Card(
      margin: EdgeInsets.all(4),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16),
        child: Row(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(item.name),
                SizedBox(height: 10.0),
                Text(item.description),
              ],
            ),
            Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("\$${item.price}"),
                SizedBox(height: 10.0),
                Text("${item.stock} in stock"),
              ],
            )
          ],
        )
      ),
    );
  }
}