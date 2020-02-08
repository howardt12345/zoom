import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:zoom/components/classes.dart';

class StoreManager extends Model {
  Store store;
  List<Order> orders = [];

  Future<dynamic> init() async {
    print("Hola");
    var data = (await Firestore.instance.collection("stores").document("zcBX7jsheLbfgCyqMMiR").get()).data;
    store = Store(
      name: data["name"],
      email: data["email"],
      address: data["address"]
    );
    return null;
  }

  void addOrder(Client client, List<Item> items, Driver driver, String id) {
    orders.add(new Order(client: client, items: items, driver: driver, id: id));
    notifyListeners();
  }
}