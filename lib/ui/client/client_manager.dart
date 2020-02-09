
import 'package:place_picker/place_picker.dart';
import 'package:scoped_model/scoped_model.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoom/components/classes.dart';

double _salesTaxRate = 0.13;
double _shippingCostPerItem = 1.0;

class ClientManager extends Model {
  Client client;
  Map<String, int> cart = <String, int>{};
  List<Item> items = [];

  Future<dynamic> init() async {
    var user = await FirebaseAuth.instance.currentUser();
    var data = (await Firestore.instance.collection('users').document(user.uid).get()).data;
    client = Client(
      name: data['name'],
      email: data['email'],
      phone: data['phone'] ?? '',
      photoUrl: user.photoUrl ?? null,
      addresses: data['addresses'] ?? [],
      favoriteItems: data['fav'] ?? [],
    );
    return null;
  }

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

  addAddress(LocationResult result) async {
    client.addresses.add(result.formattedAddress);

    var user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('users').document(user.uid).updateData({
      'addresses': client.addresses,
    });
    if(client.defaultAddress == null) {
      client.defaultAddress = result.formattedAddress;
    }
  }

  get name => client.name;
  get email => client.email;
  get phone => client.phone;
  get addresses => client.addresses;
  get favoriteItems => client.favoriteItems;
}