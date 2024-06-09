import 'package:flutter/material.dart';

class DivisionDepartmentScreen extends StatefulWidget {
  const DivisionDepartmentScreen({super.key});

  @override
  State<DivisionDepartmentScreen> createState() =>
      _DivisionDepartmentScreenState();
}

class _DivisionDepartmentScreenState extends State<DivisionDepartmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Division Department'),),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Column(children: [],),
    ),
    );
  }
}
