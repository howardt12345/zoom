

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
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  FocusNode _focusNodeName = FocusNode();
  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodePass = FocusNode();
  FocusNode _focusNodeConfirmPass = FocusNode();

  ScrollController scrollController = ScrollController();

  bool signUp = false;
  String errorMessage = '';

  googleButton() => Container(
      height: 40.0,
      width: 120,
      decoration: outlineDecoration(context),
      child: FlatButton(
        onPressed: () async {
          try {
            Navigator.of(context).push(
                FadeAnimationRoute(builder: (context) => LoadingScreen(
                  SignInMethod.google,
                ))
            ).then((onValue) {
              print(onValue);
              if(onValue == true) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    FadeAnimationRoute(builder: (context) => widget.nextPage)
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
  facebookButton() => Container(
      height: 40.0,
      decoration: outlineDecoration(context),
      child: FlatButton(
        onPressed: () async {
          try {
            Navigator.of(context).push(
                FadeAnimationRoute(builder: (context) => LoadingScreen(
                  SignInMethod.facebook,
                ))
            ).then((onValue) {
              print(onValue);
              if(onValue == true) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    FadeAnimationRoute(builder: (context) => widget.nextPage)
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

  loginBanner() => Container(
/*    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue[900], Colors.blue[100]]
      )
    ),*/
    child: Center(
      child: Container(
        padding: EdgeInsets.all(48.0),
        child: Image.asset(
          "assets/images/zoom-logo.png"
        ),
      )
      /*RichText(
        text: TextSpan(
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

  loginSignUpToggle() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        height: 40.0,
        child: FlatButton(
          child: Text('LOGIN'),
          onPressed: signUp ? () => setState(() => signUp = false) : null,
          disabledTextColor: Theme.of(context).textTheme.body2.color,
          textColor: Theme.of(context).textTheme.body2.color.withAlpha(125),
        ),
        decoration: !signUp ? outlineDecoration(context) : null,
      ),
      Container(
        height: 40.0,
        child: FlatButton(
          child: Text('SIGN UP'),
          onPressed: !signUp ? () => setState(() => signUp = true) : null,
          disabledTextColor: Theme.of(context).textTheme.body2.color,
          textColor: Theme.of(context).textTheme.body2.color.withAlpha(125),
        ),
        decoration: signUp ? outlineDecoration(context) : null,
      ),
    ],
  );

  loginForm() => Container(
    margin: EdgeInsets.all(16.0),
    child: Column(
      children: <Widget>[
        Container(
          child: signUp ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            height: fieldHeight,
            decoration: outlineDecoration(context),
            child: TextFormField(
              focusNode: _focusNodeName,
              controller: _nameController,
              decoration: InputDecoration.collapsed(hintText: "Name"),
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 16.0,
              ),
            ),
          ) : Container(height: 0.0),
        ),
        Container(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            height: fieldHeight,
            decoration: outlineDecoration(context),
            child: TextFormField(
              focusNode: _focusNodeEmail,
              controller: _emailController,
              decoration: InputDecoration.collapsed(hintText: "Email"),
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        Container(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            height: fieldHeight,
            decoration: outlineDecoration(context),
            child: TextFormField(
              focusNode: _focusNodePass,
              controller: _passController,
              decoration: InputDecoration.collapsed(hintText: "Password"),
              obscureText: true,
              autocorrect: false,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        Container(
          child: signUp ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            height: fieldHeight,
            decoration: outlineDecoration(context),
            child: TextFormField(
              focusNode: _focusNodeConfirmPass,
              controller: _confirmPassController,
              decoration: InputDecoration.collapsed(hintText: "Confirm Password"),
              obscureText: true,
              autocorrect: false,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 16.0,
              ),
            ),
          ) : Container(height: 0.0),
        ),
        errorMessage.isNotEmpty ? Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          height: 16.0,
          child: RichText(
            text: TextSpan(
              text: errorMessage,
              style: Theme.of(context).textTheme.body2.copyWith(
                  fontSize: 14.0,
                  color: Colors.red
              ),
            ),
          ),
        ) : Container(height: 8.0),
        Container(
          height: 40.0,
          child: FlatButton(
            onPressed: _confirmPressed,
            child: Text(signUp ? 'SIGN UP' : 'LOGIN'),
          ),
          decoration: outlineDecoration(context),
        ),
        Divider(height: 32.0,),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: googleButton(),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
            /*Expanded(
              child: Container(
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

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
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

    RegExp exp = RegExp(p);
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
        FadeAnimationRoute(builder: (context) => LoadingScreen(
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
            FadeAnimationRoute(builder: (context) => widget.nextPage)
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
    return Scaffold(
      body: Center(
        child: FutureBuilder<FirebaseUser>(
          future: auth.signInMethod(method, email: email, password: password, signUp: signUp, name: name),
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            switch(snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if(snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Navigator.pop(context, true);
                  return Container();
                }
            }
          },
        ),
      ),
    );
  }
}