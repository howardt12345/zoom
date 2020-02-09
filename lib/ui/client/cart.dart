

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:zoom/components/classes.dart';
import 'package:zoom/components/colors.dart';
import 'package:zoom/ui/client/shopping_cart.dart';
import 'package:zoom/utils/slide_animation_route.dart';

double _salesTaxRate = 0.13;
double _shippingCostPerItem = 1.0;

class Cart extends Model {
  String clientID, clientName;
  Map<String, int> cart = <String, int>{};
  List<Item> items = [];

  Cart(this.clientID, this.clientName);

  // Adds a product to the cart.
  void addProductToCart(Item item) {
    print(item.id);
    if (!cart.containsKey(item.id)) {
      cart[item.id] = 1;
      items.add(item);
    } else {
      cart[item.id]++;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(Item item) {
    if (cart.containsKey(item.id)) {
      if (cart[item.id] == 1) {
        cart.remove(item.id);
        items.removeWhere((element) => element.id == item.id);
      } else {
        cart[item.id]--;
      }
    }

    notifyListeners();
  }

  getItem(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  get cartItems => cart.keys.toList();
  get length => cart.values.fold(0, (p, c) => p + c);

  double get subtotalCost {
    return cart.keys
        .map((String id) => getItem(id).price * cart[id])
        .fold(0.0, (double sum, var e) => sum + e);
  }

  double get shippingCost {
    return _shippingCostPerItem * cart.length;
  }

  double get tax => subtotalCost * _salesTaxRate;

  double get totalCost => subtotalCost + shippingCost + tax;

  clearCart() {
    cart.clear();
    notifyListeners();
  }

  get keys => cart.keys;
}

class CartBottomIcon extends StatelessWidget {
  final Cart cart;
  final VoidCallback onClose;
  CartBottomIcon({this.cart, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        badgeContent: Text('${cart.length}'),
        child: IconButton(
          iconSize: 30.0,
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () => Navigator.of(context).push(
            SlideAnimationRoute(
              page: ShoppingCart(cart: cart,),
              offset: Offset(0, 1),
              curve: Curves.decelerate,
            )
          ).then((value) => onClose()),
        ),
      ),
    );
  }
}
