

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/components/decoration.dart';
import 'package:zoom/ui/client/client_manager.dart';


const double _leftColumnWidth = 60.0;


class ShoppingCart extends StatefulWidget {
  final ClientManager manager;

  ShoppingCart({this.manager});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<Widget> _createShoppingCartRows() {
    return widget.manager.cart.keys.map((String id) => ShoppingCartRow(
      item: widget.manager.getItem(id),
      quantity: widget.manager.cart[id],
      onRemove: () {
        setState(() {
          widget.manager.removeItemFromCart(widget.manager.getItem(id));
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
                    Text('${widget.manager.length} ITEMS'),
                  ],
                ),
                Column(
                  children: _createShoppingCartRows(),
                ),
                ShoppingCartSummary(manager: widget.manager,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class ShoppingCartSummary extends StatelessWidget {

  const ShoppingCartSummary({this.manager});

  final ClientManager manager;

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
                          formatter.format(manager.subtotalCost),
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
                          formatter.format(manager.shippingCost),
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
                          formatter.format(manager.tax),
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
                          formatter.format(manager.totalCost),
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
        manager.length > 0 ? Container(
          height: 40.0,
          decoration: outlineDecoration(context),
          child: FlatButton(
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
        ) : Container(),
        const SizedBox(height: 16.0),
      ],
    );
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
            width: _leftColumnWidth,
            child: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onRemove,
            ),
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