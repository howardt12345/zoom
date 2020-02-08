

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:zoom/components/decoration.dart';

import 'package:zoom/ui/login/utils/auth.dart';
import 'package:zoom/utils/fade_animation_route.dart';

import 'utils/auth.dart' as auth;

double fontSize = 20, fieldHeight = 48.0;

class LoginPage extends StatefulWidget {
  final Widget nextPage;

  LoginPage({
    @required this.nextPage,
  });

  @override
  _LoginPageState createState() => new _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {


  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  final TextEditingController _confirmPassController = new TextEditingController();

  FocusNode _focusNodeName = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodePass = new FocusNode();
  FocusNode _focusNodeConfirmPass = new FocusNode();

  ScrollController scrollController = new ScrollController();

  bool signUp = false;
  String errorMessage = '';

  googleButton() => new Container(
      height: 40.0,
      width: 120,
      decoration: outlineDecoration(context),
      child: new FlatButton(
        onPressed: () async {
          try {
            Navigator.of(context).push(
                new FadeAnimationRoute(builder: (context) => LoadingScreen(
                  SignInMethod.google,
                ))
            ).then((onValue) {
              print(onValue);
              if(onValue == true) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    new FadeAnimationRoute(builder: (context) => widget.nextPage)
                );
              }
            });
          } catch(e) {
            print(e);
          }
        },
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/g-logo.png',
                width: 18.0,
                height: 18.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('LOGIN'),
              )
            ]
        ),
      )
  );
  facebookButton() => new Container(
      height: 40.0,
      decoration: outlineDecoration(context),
      child: new FlatButton(
        onPressed: () async {
          try {
            Navigator.of(context).push(
                new FadeAnimationRoute(builder: (context) => LoadingScreen(
                  SignInMethod.facebook,
                ))
            ).then((onValue) {
              print(onValue);
              if(onValue == true) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    new FadeAnimationRoute(builder: (context) => widget.nextPage)
                );
              }
            });
          } catch(e) {
            print(e);
          }
        },
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/f-logo-${
                    Theme.of(context).brightness == Brightness.light ? 'c' : 'w'}.png',
                width: 18.0,
                height: 18.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('LOGIN'),
              )
            ]
        ),
      )
  );

  loginBanner() => new Container(
/*    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue[900], Colors.blue[100]]
      )
    ),*/
    child: new Center(
      child: Container(
        padding: EdgeInsets.all(48.0),
        child: Image.asset(
          "assets/images/zoom-logo.png"
        ),
      )
      /*new RichText(
        text: new TextSpan(
          text: 'Logo Here',
          style: Theme.of(context).textTheme.body2.copyWith(
            fontSize: fontSize*2,
          ),
        ),
      )*/,
    ),
  );

  loginFields() => Container(

    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          loginSignUpToggle(),
          loginForm(),
        ],
      ),
    ),
  );

  loginSignUpToggle() => new Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new Container(
        height: 40.0,
        child: new FlatButton(
          child: new Text('LOGIN'),
          onPressed: signUp ? () => setState(() => signUp = false) : null,
          disabledTextColor: Theme.of(context).textTheme.body2.color,
          textColor: Theme.of(context).textTheme.body2.color.withAlpha(125),
        ),
        decoration: !signUp ? outlineDecoration(context) : null,
      ),
      new Container(
        height: 40.0,
        child: new FlatButton(
          child: new Text('SIGN UP'),
          onPressed: !signUp ? () => setState(() => signUp = true) : null,
          disabledTextColor: Theme.of(context).textTheme.body2.color,
          textColor: Theme.of(context).textTheme.body2.color.withAlpha(125),
        ),
        decoration: signUp ? outlineDecoration(context) : null,
      ),
    ],
  );

  loginForm() => new Container(
    margin: EdgeInsets.all(16.0),
    child: new Column(
      children: <Widget>[
        new Container(
          child: signUp ? new Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            height: fieldHeight,
            decoration: outlineDecoration(context),
            child: new TextFormField(
              focusNode: _focusNodeName,
              controller: _nameController,
              decoration: new InputDecoration.collapsed(hintText: "Name"),
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 16.0,
              ),
            ),
          ) : new Container(height: 0.0),
        ),
        new Container(
          child: new Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            height: fieldHeight,
            decoration: outlineDecoration(context),
            child: new TextFormField(
              focusNode: _focusNodeEmail,
              controller: _emailController,
              decoration: new InputDecoration.collapsed(hintText: "Email"),
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        new Container(
          child: new Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            height: fieldHeight,
            decoration: outlineDecoration(context),
            child: new TextFormField(
              focusNode: _focusNodePass,
              controller: _passController,
              decoration: new InputDecoration.collapsed(hintText: "Password"),
              obscureText: true,
              autocorrect: false,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        new Container(
          child: signUp ? new Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            height: fieldHeight,
            decoration: outlineDecoration(context),
            child: new TextFormField(
              focusNode: _focusNodeConfirmPass,
              controller: _confirmPassController,
              decoration: new InputDecoration.collapsed(hintText: "Confirm Password"),
              obscureText: true,
              autocorrect: false,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 16.0,
              ),
            ),
          ) : new Container(height: 0.0),
        ),
        errorMessage.isNotEmpty ? new Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          height: 16.0,
          child: new RichText(
            text: new TextSpan(
              text: errorMessage,
              style: Theme.of(context).textTheme.body2.copyWith(
                  fontSize: 14.0,
                  color: Colors.red
              ),
            ),
          ),
        ) : new Container(height: 8.0),
        new Container(
          height: 40.0,
          child: new FlatButton(
            onPressed: _confirmPressed,
            child: new Text(signUp ? 'SIGN UP' : 'LOGIN'),
          ),
          decoration: outlineDecoration(context),
        ),
        new Divider(height: 32.0,),
        new Row(
          children: <Widget>[
            new Expanded(
              child: new Container(
                child: googleButton(),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
            /*new Expanded(
              child: new Container(
                child: facebookButton(),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),*/
          ],
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: new Scaffold(
        body: new SafeArea(
          child: new Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: loginBanner(),
                  ),
                  Expanded(
                    flex: 2,
                    child: loginFields(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmPressed() {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    var name = _nameController.text.trim();
    var email = _emailController.text.trim();
    var pass = _passController.text;
    var confirmPass = _confirmPassController.text;

    RegExp exp = new RegExp(p);
    if(!exp.hasMatch(email)) {
      setState(() => errorMessage = 'Email address is invalid');
      return;
    }
    if(pass.length < 6) {
      setState(() => errorMessage = 'Password is too short');
      return;
    }
    if(signUp) {
      if (confirmPass != pass) {
        setState(() => errorMessage = 'Passwords do not match');
        return;
      }
    }

    _nameController.clear();
    _emailController.clear();
    _passController.clear();
    _confirmPassController.clear();

    Navigator.of(context).push(
        new FadeAnimationRoute(builder: (context) => LoadingScreen(
          SignInMethod.email,
          email: email,
          password: pass,
          signUp: signUp,
          name: name,
        ))
    ).then((onValue) {
      print(onValue);
      if(onValue == true) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
            new FadeAnimationRoute(builder: (context) => widget.nextPage)
        );
      }
    });
  }
}

class LoadingScreen extends StatelessWidget {

  final String name, email, password;
  final bool signUp;
  final SignInMethod method;
  LoadingScreen(this.method, {
    this.signUp = false,
    this.name,
    this.email,
    this.password,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new FutureBuilder<FirebaseUser>(
          future: auth.signInMethod(method, email: email, password: password, signUp: signUp, name: name),
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            switch(snapshot.connectionState) {
              case ConnectionState.waiting:
                return new CircularProgressIndicator();
              default:
                if(snapshot.hasError) {
                  return new Text('Error: ${snapshot.error}');
                } else {
                  Navigator.pop(context, true);
                  return new Container();
                }
            }
          },
        ),
      ),
    );
  }
}