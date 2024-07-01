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
                  "Sportify is a sports field reservation application that includes badminton, futsal, basketball, volleyball, and tennis courts. 'Sportify' stands for 'Sports Facilities Reservation and Integration System'. Sportify offers various menus such as home screen, history, settings, profile, notifications, about apps, and features like court listings, booking and payment, and game schedule reminders.",
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
                  items: imgList.map((item) => Center(
                    child: Image.asset(item, fit: BoxFit.contain, width: 1000),
                  )).toList(),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Main Feature:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const BulletPoint(text: 'Easy sports field search'),
                const BulletPoint(text: 'Detailed information about the fields, from location to hourly rates'),
                const BulletPoint(text: 'Online field reservation'),
                const BulletPoint(text: 'Reservation reminder notifications'),
                const SizedBox(height: 30),
                const Text(
                  'Developer Team:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const BulletPoint(text: 'Ni Kadek Dwi Prasetyanti'),
                const BulletPoint(text: 'Gede Yogi Indra Permana'),
                const BulletPoint(text: 'I Made Wipayoga'),
                const BulletPoint(text: 'Ni Kadek Wisdayani'),
                const SizedBox(height: 30),
                const Text(
                  'Customer Contact and Support:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const BulletPoint(text: 'Email : support@sportify.com'),
                const BulletPoint(text: 'WhatsApp : +62 812-3456-7890'),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}