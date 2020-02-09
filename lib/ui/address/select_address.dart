

import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:zoom/components/colors.dart';

import 'package:zoom/ui/client/client_manager.dart';

class SelectAddressPage extends StatefulWidget {
  final ClientManager manager;

  SelectAddressPage({this.manager});

  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {

  addressTile(String address) => ListTile(
    leading: IconButton(
      icon: Icon(Icons.location_on),
      color: widget.manager.client.defaultAddress == address ? primaryColor : Theme.of(context).textTheme.button.color,
    ),
    title: Text(
      address.split(',')[0],
      style: Theme.of(context).textTheme.button.copyWith(
          color: widget.manager.client.defaultAddress == address ? primaryColor : Theme.of(context).textTheme.button.color,
      ),
    ),
    subtitle: Text(
      '${address.split(',')[1]}, ${address.split(',')[2]}' ?? address,
      style: Theme.of(context).textTheme.button.copyWith(
        color: widget.manager.client.defaultAddress == address ? secondaryColor : Theme.of(context).textTheme.button.color,
      ),
    ),
    onTap: () {
      setState(() {
        widget.manager.client.defaultAddress = address;
      });
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                color: Theme.of(context).textTheme.button.color,
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: <Widget>[
                IconButton(
                  color: Theme.of(context).textTheme.button.color,
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
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(78.0),
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.body1.copyWith(
                            fontSize: 32.0
                        ),
                        text: 'Delivery Addresses'
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                widget.manager.client.addressesAsString().map<Widget>((a) => addressTile(a)).toList()
              ),
            ),
          ],
        ),
      ),
    );
  }
}
