import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/bullet_point.dart'; // pastikan path ini sesuai dengan lokasi file BulletPoint Anda

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/images/prototype.png',
      'assets/images/about_ss.png',
      'assets/images/about_hisp.png',
      'assets/images/about_hp.png',
      'assets/images/about_lp.png',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("About Apps"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: RadialGradient(colors: [
            Color.fromARGB(255, 90, 137, 158),
            Constants.scaffoldBackgroundColor
          ], focal: Alignment.center, radius: 1.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    "SPORTIFY",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Image(
                    image: AssetImage("assets/images/icon_sportify.png"),
                    width: 120,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sportify adalah sebuah aplikasi reservasi lapangan olahraga yang terdiri dari lapangan badminton, futsal, basket, voli dan tennis. 'Sportify' merupakan kepanjangan dari 'Sports Facilities Reservation and Integration System'. Sportify menyediakan beberapa menu seperti home screen, history, setting, profile, notification, about apps dan beberapa fitur seperti list lapangan, pemesanan dan pembayaran, serta pengingat jadwal bermain.",
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 500.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    viewportFraction: 0.8,
                  ),
                  items: imgList.map((item) => Container(
                    child: Center(
                      child: Image.asset(item, fit: BoxFit.contain, width: 1000),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Fitur Utama:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const BulletPoint(text: 'Pencarian lapangan olahraga yang mudah'),
                const BulletPoint(text: 'Informasi detail lapangan mulai dari lokasi hingga harga perjamnya'),
                const BulletPoint(text: 'Reservasi lapangan secara online'),
                const BulletPoint(text: 'Notifikasi pengingat reservasi'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}