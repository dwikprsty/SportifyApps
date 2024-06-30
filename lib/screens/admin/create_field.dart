import 'package:flutter/material.dart';
import 'package:sportify_app/utils/constants.dart';

class CreateFields extends StatefulWidget {
  const CreateFields({super.key});

  @override
  State<CreateFields> createState() => _CreateFieldsState();
}

class _CreateFieldsState extends State<CreateFields> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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