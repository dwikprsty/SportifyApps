import 'package:flutter/material.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
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
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: Constants.primaryColor,
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/basketball.jpg'),
                      radius: 45,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Dwi Prasetyanti",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  const InputWidget(
                    hintText: "Input your nick name",
                    topLabel: "Nick name",
                  ),
                  const SizedBox(height: 15),
                  const InputWidget(
                    hintText: "input your username name",
                    topLabel: "Username",
                  ),
                  const SizedBox(height: 15),
                  const InputWidget(
                    hintText: "input your e-mail address",
                    topLabel: "E-mail address",
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Expanded(
                        child: InputWidget(
                          hintText: "your gender",
                          topLabel: "Gender",
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: InputWidget(
                          hintText: "your birthday",
                          topLabel: "Birthday",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const InputWidget(
                    hintText: 'input your phone number',
                    topLabel: 'Phone number',
                  ),
                  const SizedBox(height: 50),
                  AppButton(
                      type: ButtonType.PRIMARY, onPressed: () {}, text: 'Edit')
                ],
              ),
            ),
          ),
        ));
  }
}
