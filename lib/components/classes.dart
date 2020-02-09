
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Object {
  String id;
  Object(this.id);
}

class Profile extends Object {
  String name, email, phone, photoUrl;

  Profile({
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    @required String id
  }) : super(id);
}

class Client extends Profile {
  List<Item> favoriteItems;
  List<dynamic> addresses;
  String defaultAddress;

  Client({
    String id,
    String name,
    String email,
    String phone,
    String photoUrl,
    this.defaultAddress,
    this.favoriteItems = const [],
    this.addresses = const [],
  }) : super(
    id: id,
    name: name,
    email: email,
    phone: phone,
    photoUrl: photoUrl,
  );

  List<String> addressesAsString() => addresses.map((e) => e.toString()).toList();
}

class Driver extends Profile {
  bool available;
  double rating;
  String licensePlate;

  Driver({
    String name,
    String email,
    String phone,
    this.available,
    this.rating,
    this.licensePlate,
  }) : super(
    name: name,
    email: email,
    phone: phone,
  );
}

class Store extends Profile {
  String address;
  double rating;
  List<dynamic> hours;
  List<Item> items;

  Store({
    String id,
    String name,
    String email,
    String phone,
    String photoUrl,
    this.address,
    this.rating,
    this.hours,
    this.items,
  }) : super(
    id: id,
    name: name,
    email: email,
    phone: phone,
    photoUrl: photoUrl,
  );

  SplayTreeMap<String, List<Item>> itemsByCategory() {
    SplayTreeMap<String, List<Item>> tmp = SplayTreeMap<String, List<Item>>();
    for(Item item in items) {
      if(tmp[item.category] == null) {
        tmp[item.category] = [];
      }
      tmp[item.category].add(item);
    }
    return tmp;
  }
}

class Item extends Object {
  String name, category, description, image, store;
  double price, rating;
  int stock;

  Item({
    @required String id,
    this.name,
    this.description,
    this.category,
    this.price,
    this.store,
    this.rating,
    this.image,
    this.stock,
  }) : super(id);
}

enum ORDER_STATUS {
  PENDING,
  CONFIRMED,
  IN_TRANSIT,
  DELIVERED,
  CANCELLED
}

class Order extends Object {
  String clientID, clientName, storeID;
  Map<String, int> items = Map<String, int>();
  double price;
  ORDER_STATUS status = ORDER_STATUS.PENDING;

  Order({
    @required String id,
    this.clientID,
    this.clientName,
    this.storeID,
    this.price,
  }) : super(id);
}