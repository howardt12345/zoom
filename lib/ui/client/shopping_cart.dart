

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoom/ui/client/client_manager.dart';


const double _leftColumnWidth = 60.0;


class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class ShoppingCartSummary extends StatelessWidget {
  const ShoppingCartSummary({this.manager});

  final ClientManager manager;

  @override
  Widget build(BuildContext context) {
    final TextStyle largeAmountStyle = Theme.of(context).textTheme.headline4;
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );

    return Row(
      children: <Widget>[
        const SizedBox(width: _leftColumnWidth),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: <Widget>[
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
                      child: Text('Shipping:'),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}