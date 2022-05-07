import 'package:flutter/material.dart';

//custom fade animation
class FadePageRoute extends PageRouteBuilder {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
    pageBuilder: (
        context,
        animation,
        secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}