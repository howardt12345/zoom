

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

  Future<void> changeName(String name) async {
    store.name = name;
    await Firestore.instance.collection("stores").document(id).updateData({
      'name': name,
    });
    return null;
  }

  Future<void> changeAddress(String address) async {
    store.address = address;
    await Firestore.instance.collection("stores").document(id).updateData({
      'address': address,
    });
    return null;
  }
}