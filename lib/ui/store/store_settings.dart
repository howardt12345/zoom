


import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:zoom/components/colors.dart';
import 'package:zoom/components/decoration.dart';
import 'package:zoom/ui/store/store_manager.dart';

class StoreSettings extends StatefulWidget {
  final StoreManager storeManager;

  StoreSettings(this.storeManager);

  @override
  _StoreSettingsState createState() => _StoreSettingsState();
}

class _StoreSettingsState extends State<StoreSettings> {

  bool loading = false;

  TextEditingController editingController;

  void initState() {
    super.initState();
    editingController = TextEditingController(text: widget.storeManager.store.name);
  }

  Future<String> showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => PlacePicker("AIzaSyCK4H4ZX6D7dtE0l59iCksJt9Im-myHoQ4",)
        )
    );
    // Handle the result in your way
    return result.formattedAddress;
  }

  selectAddressButton() => FlatButton(
    onPressed: () => showPlacePicker().then((value) {
      setState(() {
        widget.storeManager.store.address = value;
      });
      return null;
    }),
    child: Text(
      widget.storeManager.store.address.split(',')[0],
      style: Theme.of(context).textTheme.button.copyWith(
          fontSize: 16,
          color: secondaryColor
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading ? CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(78.0),
              child: ListTile(
                title: RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.body1.copyWith(
                          fontSize: 32.0
                      ),
                      text: 'Settings:'
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Name:   "),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Store name"
                          ),
                          controller: editingController,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16.0,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Address:   "),
                      Expanded(
                        child: selectAddressButton(),
                      )
                    ],
                  ),
                  SizedBox(height: 16.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        decoration: outlineDecoration(context),
                        child: FlatButton(
                          child: Text("ACCEPT"),
                          onPressed: () async {
                            await widget.storeManager.changeName(editingController.text);
                            await widget.storeManager.changeAddress(widget.storeManager.store.address);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Container(
                        decoration: outlineDecoration(context),
                        child: FlatButton(
                          child: Text("CANCEL"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}
