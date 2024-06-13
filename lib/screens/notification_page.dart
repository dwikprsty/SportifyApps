import 'package:flutter/material.dart';
import 'package:sportify_app/utils/constants.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Notification"),
      ),
      body: Container(
         width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: RadialGradient(colors: [
          Color.fromARGB(255, 90, 137, 158),
          Constants.scaffoldBackgroundColor
        ], focal: Alignment.center, radius: 1.0)),
      ),
    );
  }
}
