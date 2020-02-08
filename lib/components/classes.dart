
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
    String name,
    String email,
    String phone,
    String photoUrl,
    this.defaultAddress,
    this.favoriteItems = const [],
    this.addresses = const [],
  }) : super(
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
  List<String> hours;
  List<Item> items;

  Store({
    String name,
    String email,
    String phone,
    this.address,
    this.rating,
    this.hours,
    this.items,
  }) : super(
    name: name,
    email: email,
    phone: phone,
  );
}

class Item extends Object {
  String name, category, description, image;
  double price, rating;
  int stock;

  Item({
    @required String id,
    this.name,
    this.description,
    this.category,
    this.price,
    this.rating,
    this.image,
    this.stock,
  }) : super(id);
}

class Order extends Object {
  Client client;
  List<Item> items;
  Driver driver;
  double price;

  Order({
    this.client,
    this.items,
    this.driver,
    @required String id,
  }) : super(id) {
    price = 19.95;
  }
}