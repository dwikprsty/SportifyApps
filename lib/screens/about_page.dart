import 'package:flutter/material.dart';
import 'package:sportify_app/utils/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("About Apps"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: RadialGradient(colors: [
          Color.fromARGB(255, 90, 137, 158),
          Constants.scaffoldBackgroundColor
        ], focal: Alignment.center, radius: 1.0)),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  "SPORTIFY",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
                Image(
                  image: AssetImage("assets/images/icon_sportify.png"),
                  width: 200,
                ),
                SizedBox(height: 20),
                Text(
                  "Sportify adalah sebuah aplikasi reservasi lapangan olahraga yang terdiri dari lapangan badminton, futsal, basket, voli dan tennis. 'Sportify' merupakan kepanjangan dari 'Sports Facilities Reservation and Integration System'. Sportify menyediakan beberapa menu seperti home screen, history, setting, profile, notification, about apps dan beberapa fitur seperti list lapangan, pemesanan dan pembayaran, serta pengingat jadwal bermain.",
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
