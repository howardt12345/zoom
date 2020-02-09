

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoom/components/classes.dart';

class ListingsManager {
  List<Store> stores = [];
  String storeID;

  Future<void> init() async {
    stores = [];
    QuerySnapshot storesSnapshot = await Firestore.instance.collection("stores").getDocuments();
    var list = storesSnapshot.documents;
    for(var document in list) {
      var data = document.data;
      Store store = Store(
        id: document.documentID,
        address: data['address'],
        name: data['name'],
        phone: data['phone'],
        photoUrl: data['image'],
        items: [],
        rating: data['rating'],
        hours: data['hours'],
      );

      QuerySnapshot itemsSnapshot = await Firestore.instance.collection("stores").document(document.documentID).collection('items').getDocuments();
      var items = itemsSnapshot.documents;
      for(var item in items) {
        var itemData = item.data;
        store.items.add(Item(
          id: item.documentID,
          store: document.documentID,
          description: itemData['desc'],
          category: itemData['category'],
          image: itemData['image'],
          name: itemData['name'],
          price: itemData['price'],
          rating: itemData['rating']*1.0,
          stock: itemData['stock'],
        ));
      }

      stores.add(store);
    }
    return null;
  }
}