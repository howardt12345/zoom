
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom/components/decoration.dart';
import 'package:zoom/ui/main.dart';
import 'package:zoom/utils/fade_animation_route.dart';

FirebaseUser user;

class StateSelectPage extends StatefulWidget {

  @override
  _StateSelectPageState createState() => _StateSelectPageState();
}

class _StateSelectPageState extends State<StateSelectPage> {
  PageState _pageState = PageState.none;

  void initState() {
    super.initState();
  }

  nameBanner() => Container(
    padding: EdgeInsets.all(24.0),
    child: new Center(
      child: new RichText(
        text: new TextSpan(
          text: 'Hello ${user.displayName ?? 'null'}!',
          style: Theme.of(context).textTheme.body2.copyWith(
            fontSize: 20.0*2,
          ),
        ),
      ),
    ),
  );

  statePicker() => Container(
    child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: RichText(
            text: TextSpan(
              text: "Are you a:",
              style: Theme.of(context).textTheme.subhead.copyWith(
                fontSize: 20.0
              ),
            ),
          ),
        ),
        stateButton(PageState.Client),
        stateButton(PageState.Driver),
        stateButton(PageState.Store),
        Container(height: 32.0,),
        confirmButton(),
      ],
    ),
  );

  stateButton(PageState state) => Container(
    child: FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(12.0),
        side: BorderSide(
          color: _pageState == state
              ? Theme.of(context).textTheme.body2.color
              : Theme.of(context).textTheme.body2.color.withAlpha(50)
        )
      ),
      child: Text(
        EnumToString.parse(state),
        style: Theme.of(context).textTheme.body2,
      ),
      onPressed: () => setState(() => this._pageState = state),
    ),
  );

  confirmButton() => Container(
    height: 48.0,
    width: 128.0,
    decoration: outlineDecoration(context),
    child: FlatButton(
      child: Text(
        "CONFIRM",
        style: Theme.of(context).textTheme.body2.copyWith(
          fontSize: 16.0
        ),
      ),
      onPressed: _pageState != PageState.none ? confirm : null,
    ),
  );

  confirm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("state", EnumToString.parse(_pageState)).then((value) =>
        Navigator.of(context).push(FadeAnimationRoute(builder: (context) => MainPage()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data != null) {
              user = snapshot.data;
              print(user.displayName);
              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: nameBanner(),
                  ),
                  Expanded(
                    flex: 3,
                    child: statePicker(),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
          },
        ),
      ),
    );
  }
}
