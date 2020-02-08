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

  String status = "Pending";

  _OrderPageState(Order order) {
    this.order = order;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.shopping_cart)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
          title:
              Text("Order ${order.id} for ${order.client.name.split(" ")[0]}"),
        ),
        body: (TabBarView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: _itemListBuilder,
                itemCount: order.items.length,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Text(
                      "STATUS: ${order.getStatus()}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  DropdownButton<String>(
                    value: status,
                    items: <String>[
                      "Pending",
                      "Confirmed",
                      "In transit",
                      "Delivered",
                      "Cancelled"
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        status = value;
                        switch (value) {
                          case "Pending":
                            order.status = ORDER_STATUS.PENDING;
                            break;
                          case "Confirmed":
                            order.status = ORDER_STATUS.CONFIRMED;
                            break;
                          case "In transit":
                            order.status = ORDER_STATUS.IN_TRANSIT;
                            break;
                          case "Delivered":
                            order.status = ORDER_STATUS.DELIVERED;
                            break;
                          case "Cancelled":
                            order.status = ORDER_STATUS.CANCELLED;
                            break;
                          default:
                            order.status = ORDER_STATUS.PENDING;
                            break;
                        }
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        )),
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
          )),
    );
  }
}
