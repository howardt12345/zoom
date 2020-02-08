import 'package:flutter/material.dart';


class SlideAnimationRoute extends PageRouteBuilder {
  final Widget page;
  final Offset offset;
  final Curve curve;
  SlideAnimationRoute({
    this.page,
    this.offset = Offset.zero,
    this.curve = Curves.linear,
  })
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: offset,
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: child,
        ),
  );
}