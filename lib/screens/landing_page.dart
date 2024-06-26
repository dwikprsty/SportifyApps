import 'package:flutter/material.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/landing_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(), // This pushes the content to the bottom
              const Text(
                "Begin a Healthy Journey with SPORTIFY!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Effortlessly Carve Out Your Practice Sessions",
                style: TextStyle(
                  fontSize: 14,
                  color: Constants.activeMenu,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AppButton(
                type: ButtonType.PLAIN,
                text: "Get Started!",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/register");
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
