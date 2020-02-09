

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoom/components/categories.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/ui/client/cart.dart';

class StoreCatalogPage extends StatefulWidget {
  final Cart cart;
  final Store store;

  StoreCatalogPage({
    this.cart,
    this.store,
  });

  @override
  _StoreCatalogPageState createState() => _StoreCatalogPageState();
}

class _StoreCatalogPageState extends State<StoreCatalogPage> {

  
  Widget storeItem(Item item) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );
    return ExpansionTile(
      leading: Image.network(
        item.image,
        fit: BoxFit.cover,
        width: 56.0,
        height: 56.0,
      ),
      title: RichText(
        text: TextSpan(
          text: '${item.name}',
          style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w500
          ),
          children: <TextSpan>[
            TextSpan(
            text: '\n${formatter.format(item.price)}',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400
              ),
            ),
          ]
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            categories[item.category],
            color: Theme.of(context).textTheme.button.color.withAlpha(100),
          ),
          IconButton(
            color: Theme.of(context).textTheme.button.color,
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              setState(() {
                widget.cart.addProductToCart(item);
              });
            },
          )
        ],
      ),
      children: <Widget>[
        Text(item.description)
      ],
    );
  }

  List<Widget> listings() {
    List<Widget> tmp = List<Widget>();
    var map = widget.store.itemsByCategory();
    map.forEach((key, value) {
      tmp.add(
        ListTile(
          title: Text(
            key,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontSize: 20.0,
              fontWeight: FontWeight.w600
            ),
          ),
        )
      );
      value.forEach((item) {
        tmp.add(storeItem(item));
      });
    });
    tmp.add(SizedBox(height: 56.0,));
    return tmp;
  }

  Widget storeInfo() => Column(
    children: <Widget>[
      SizedBox(height: 8.0,),
      ListTile(
        leading: IconButton(
          icon: Icon(Icons.location_on),
          color: Theme.of(context).textTheme.button.color,
        ),
        title: Text(widget.store.address),
      ),
      widget.store.phone != null ? ListTile(
        leading: IconButton(
          icon: Icon(Icons.phone),
          color: Theme.of(context).textTheme.button.color,
        ),
        title: Text(widget.store.phone),
      ) : Container(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                          widget.store.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          )
                      ),
                      background: Image.network(
                        widget.store.photoUrl,
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                SliverToBoxAdapter(
                  child: storeInfo()
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                      listings()
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: widget.cart.length > 0 ? CartBottomIcon(
                cart: widget.cart,
                onClose: () => setState(() {}),
              ) : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
