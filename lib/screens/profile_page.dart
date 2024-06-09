import 'package:flutter/material.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _selectedGender;
  String? _selectedBirthday;
  final TextEditingController _birthdayController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedBirthday = "${picked.toLocal()}".split(' ')[0];
        _birthdayController.text = _selectedBirthday!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color.fromARGB(255, 90, 137, 158),
                Constants.scaffoldBackgroundColor
              ],
              focal: Alignment.center,
              radius: 1.0,
            ),
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
                    backgroundImage: AssetImage('assets/images/basketball.jpg'),
                    radius: 45,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Dwi Prasetyanti",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                const FlexibleInputWidget(
                  hintText: "Input your nick name",
                  topLabel: "Nick name",
                ),
                const SizedBox(height: 15),
                const FlexibleInputWidget(
                  hintText: "input your username name",
                  topLabel: "Username",
                ),
                const SizedBox(height: 15),
                const FlexibleInputWidget(
                  hintText: "input your e-mail address",
                  topLabel: "E-mail address",
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: FlexibleInputWidget(isDropdown: true,
                        topLabel: 'Gender',
                        hintText: "Select gender",
                        value: _selectedGender,
                        items: const ["Laki-laki", "Perempuan"],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        fillColor: Constants.scaffoldBackgroundColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: FlexibleInputWidget(
                        hintText: "Your birthday",
                        suffixIcon: const Icon(Icons.calendar_today),
                        topLabel: "Birthday",
                        controller: _birthdayController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const FlexibleInputWidget(
                  hintText: 'input your phone number',
                  topLabel: 'Phone number',
                ),
                const SizedBox(height: 50),
                AppButton(
                  type: ButtonType.PRIMARY,
                  onPressed: () {},
                  text: 'Edit',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
