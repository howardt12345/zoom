
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User {
  FirebaseUser user;
  User({this.user});
  get uid => user.uid ?? '';
  get name => user.displayName;
  get email => user.email;
}

class Object {
  String id;
  Object(this.id);
}

class Profile extends Object {
  String name, email, phone;

  Profile({
    this.name,
    this.email,
    this.phone,
    @required String id
  }) : super(id);
}

class Client extends Profile {
  List<Item> favoriteItems;
  List<String> addresses;

  Client({
    String name,
    String email,
    String phone,
    this.favoriteItems,
    this.addresses,
  }) : super(
    name: name,
    email: email,
    phone: phone,
  );
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
  String name, description;
  double price, rating;
  bool available;

  Item({
    this.name,
    this.description,
    this.price,
    this.available,
    @required String id,
  }) : super(id);
}

class Order extends Object {
  Client client;
  Item item;
  Driver driver;

  Order({
    this.client,
    this.item,
    this.driver,
    @required String id,
  }) : super(id);
}