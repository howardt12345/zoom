
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoom/components/classes.dart';

class StoreManager {
  Store store;
  String id;

  StoreManager({this.id});

  Future<void> init() async {
    var data = (await Firestore.instance.collection("stores").document(id).get()).data;
    store = Store(
      name: data["name"],
      email: data["email"],
      address: data["address"],
      photoUrl: data['images'],
    );
  }
}