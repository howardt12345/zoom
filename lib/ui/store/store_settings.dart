import 'package:flutter/material.dart';
import 'package:zoom/ui/store/store_manager.dart';

class StoreSettings extends StatefulWidget {
  StoreManager manager;

  StoreSettings({this.manager});

  @override
  _StoreSettingsPageState createState() => _StoreSettingsPageState(manager);
}

class _StoreSettingsPageState extends State<StoreSettings> {
  StoreManager manager;

  final controller = TextEditingController();

  _StoreSettingsPageState(StoreManager manager) {
    this.manager = manager;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        child:
          Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Store name"
                ),
                controller: controller,
              ),
              FlatButton(
                color: Colors.grey,
                child: Text("Update name"),
                onPressed: () {
                  manager.updateName(controller.text);
                },
              )
            ],
          )
      ),
    );
  }
}