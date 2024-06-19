import 'package:flutter/material.dart';

void nextScreen(BuildContext context, String route, {Object? arguments}) {
  Navigator.of(context).pushNamed(
    route,
    arguments: arguments,
  );
}
