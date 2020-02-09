

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/components/decoration.dart';
import 'package:zoom/ui/client/cart.dart';
import 'package:zoom/ui/client/client_manager.dart';


const double _leftColumnWidth = 60.0;


class ShoppingCart extends StatefulWidget {
  final Cart cart;

  ShoppingCart({this.cart});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<Widget> _createShoppingCartRows() {
    return widget.cart.keys.map<Widget>((String id) => ShoppingCartRow(
      item: widget.cart.getItem(id),
      quantity: widget.cart.cart[id],
      onRemove: () {
        setState(() {
          widget.cart.removeItemFromCart(widget.cart.getItem(id));
        });
      },
    ),).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: _leftColumnWidth,
                      child: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Text(
                      'CART',
                      style: Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 16.0),
                    Text('${widget.cart.length} ITEMS'),
                  ],
                ),
                Column(
                  children: _createShoppingCartRows(),
                ),
                ShoppingCartSummary(cart: widget.cart,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class ShoppingCartSummary extends StatelessWidget {

  const ShoppingCartSummary({this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final TextStyle smallAmountStyle = Theme.of(context).textTheme.body2;
    final TextStyle largeAmountStyle = Theme.of(context).textTheme.display1;
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(width: _leftColumnWidth),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text('Subtotal:'),
                        ),
                        Text(
                          formatter.format(cart.subtotalCost),
                          style: smallAmountStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text('Delivery Fee:'),
                        ),
                        Text(
                          formatter.format(cart.shippingCost),
                          style: smallAmountStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text('Tax:'),
                        ),
                        Text(
                          formatter.format(cart.tax),
                          style: smallAmountStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Expanded(
                          child: Text('TOTAL'),
                        ),
                        Text(
                          formatter.format(cart.totalCost),
                          style: largeAmountStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        cart.length > 0 ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 40.0,
              decoration: outlineDecoration(context),
              child: FlatButton(
                onPressed: () {
                  checkout().then((value) {
                    cart.clearCart();
                    Navigator.of(context).pop();
                  });
                },
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('CHECKOUT'),
                      )
                    ]
                ),
              ),
            ),
            Container(
              height: 40.0,
              decoration: outlineDecoration(context),
              child: FlatButton(
                onPressed: () {
                  cart.clearCart();
                  Navigator.of(context).pop();
                },
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_sweep),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('CLEAR'),
                      )
                    ]
                ),
              ),
            )
          ],
        ) : Container(),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Future<void> checkout() async {
    List<String> items = [];
    cart.cart.forEach((key, value) {
      items.add('$key:$value');
    });

    await Firestore.instance.collection('orders').add({
      'store': cart.items[0].store,
      'client': cart.clientID,
      'name': cart.clientName,
      'price': cart.totalCost,
      'items': items,
    });
    return;
  }
}

class ShoppingCartRow extends StatelessWidget {
  const ShoppingCartRow({
    @required this.item,
    this.quantity = 0,
    this.onRemove,
  });

  final Item item;
  final int quantity;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );
    final ThemeData localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: onRemove != null ? _leftColumnWidth : 0,
            child: onRemove != null ? IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onRemove,
            ) : Container(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        width: 75.0,
                        height: 75.0,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text('Quantity: $quantity'),
                                ),
                                Text('x ${formatter.format(item.price)}'),
                              ],
                            ),
                            Text(
                              item.name,
                              style: localTheme.textTheme.subhead.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}