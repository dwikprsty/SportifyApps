import 'package:flutter/material.dart';
import 'package:sportify_app/utils/helper.dart';
import 'package:sportify_app/widgets/button.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/home_bg.png"),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/basketball.jpg'),maxRadius: 40,
                  ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Dwi Prasetyanti",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                    type: ButtonType.PRIMARY,
                    onPressed: () {
                      nextScreen(context, '/profile');
                    },
                    text: "Edit profile"),
                const SizedBox(
                  height: 40,
                ),
                const Divider(thickness: 2, color: Colors.black38),
                const Text('General'),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.lock),
                    Text(
                      "Privacy & Permission",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(Icons.notifications),
                    Text(
                      "Notification",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2, color: Colors.black38),
                const Text("Configurations"),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.book),
                    Text(
                      "Language",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(Icons.accessibility),
                    Text(
                      "Accessibility",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(Icons.data_usage),
                    Text(
                      "Data usage",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2, color: Colors.black38),
                const Text("Others"),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.help),
                    Text(
                      "Help & support",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
