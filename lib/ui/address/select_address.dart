

import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';

import 'package:zoom/ui/client/client_manager.dart';

class SelectAddressPage extends StatefulWidget {
  final ClientManager manager;

  SelectAddressPage({this.manager});

  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {

  addressTile(String address) => ListTile(
    leading: IconButton(icon: Icon(Icons.location_on),),
    title: Text(address.split(',')[0]),
    subtitle: Text('${address.split(',')[1]}, ${address.split(',')[2]}'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Delivery Addresses"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              LocationResult result = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => PlacePicker("AIzaSyCK4H4ZX6D7dtE0l59iCksJt9Im-myHoQ4",)
                  )
              );
              await widget.manager.addAddress(result);
            },
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: widget.manager.client.addressesAsString().map<Widget>((a) => addressTile(a)).toList(),
        ),
      ),
    );
  }
}
