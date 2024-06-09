import 'package:flutter/material.dart';

class PriorityIssuesScreen extends StatefulWidget {
  const PriorityIssuesScreen({super.key});

  @override
  State<PriorityIssuesScreen> createState() =>
      _PriorityIssuesScreenState();
}

class _PriorityIssuesScreenState extends State<PriorityIssuesScreen> {
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
