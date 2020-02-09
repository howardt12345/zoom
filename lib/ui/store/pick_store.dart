




import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zoom/ui/client/listings_manager.dart';
import 'package:zoom/ui/main.dart';
import 'package:zoom/utils/fade_animation_route.dart';

class PickStorePage extends StatefulWidget {
  @override
  _PickStorePageState createState() => _PickStorePageState();
}

class _PickStorePageState extends State<PickStorePage> {
  ListingsManager listingsManager = ListingsManager();
  bool loading = true;


  void initState() {
    super.initState();
    listingsManager.init().then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  List<Widget> storesList() => listingsManager.stores.map<Widget>((e) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('store', e.id);
              Navigator.of(context).push(FadeAnimationRoute(builder: (context) => MainPage()));
            },
            child: Container(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: e.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  e.name,
                  style: Theme.of(context).textTheme.title,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  )).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading ? SafeArea(
        child: ListView(
          children: storesList(),
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}
