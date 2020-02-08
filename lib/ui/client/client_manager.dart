
import 'package:scoped_model/scoped_model.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoom/components/classes.dart';

double _salesTaxRate = 0.13;
double _shippingCostPerItem = 1.0;

class ClientManager extends Model {
  Client client;
  List<Item> cart;

  Future<dynamic> init() async {
    var user = await FirebaseAuth.instance.currentUser();
    var data = (await Firestore.instance.collection('users').document(user.uid).get()).data;
    client = Client(
      name: data['name'],
      email: data['email'],
      phone: data['phone'] ?? '',
      addresses: data['addresses'] ?? const [],
      favoriteItems: data['fav'] ?? const [],
    );
    return null;
  }

  void addToCart(Item item) {
    cart.add(item);
    notifyListeners();
  }
  void removeFromCart(Item item) {
    cart.remove(item);
    notifyListeners();
  }

  double get subtotalCost {
    return cart.fold(0, (p, c) => p + c.price);
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

  get name => client.name;
  get email => client.email;
  get phone => client.phone;
  get addresses => client.addresses;
  get favoriteItems => client.favoriteItems;
}