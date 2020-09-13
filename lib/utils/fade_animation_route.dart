import 'package:flutter/material.dart';

Route FadeAnimationRoute({WidgetBuilder builder}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Builder(builder: builder),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}



Route fadeAnimationRoute({Widget child}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}