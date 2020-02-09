
import 'package:place_picker/place_picker.dart';
import 'package:scoped_model/scoped_model.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoom/components/classes.dart';

class ClientManager extends Model {
  Client client;

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
    if(client.addresses.isNotEmpty) {
      client.defaultAddress = client.addresses.first;
    }
    return null;
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

  removeAddress(String address) async {
    client.addresses.remove(address);

    var user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('users').document(user.uid).updateData({
      'addresses': client.addresses,
    });
    if(client.defaultAddress == address) {
      client.defaultAddress = null;
    }
  }

  get name => client.name;
  get email => client.email;
  get phone => client.phone;
  get addresses => client.addresses;
  get favoriteItems => client.favoriteItems;
}