import 'package:flutter/material.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/utils/helper.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/register_page.png"),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 160),
                const Text(
                  "Create an Account",
                  style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Text(
                  "Please fill this form to continue",
                  style: TextStyle(color: Colors.white),
                ),
                Card(
                  color: Constants.scaffoldBackgroundColor,
                  elevation: 4,
                  margin: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const FlexibleInputWidget(
                          hintText: 'Create your username',
                          topLabel: 'Username',
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 10),
                        const FlexibleInputWidget(
                          hintText: 'Example@domain.com',
                          topLabel: 'E-mail Address',
                          prefixIcon: Icons.mail,
                        ),
                        const SizedBox(height: 10),
                        FlexibleInputWidget(
                          hintText: 'Create a secure password',
                          topLabel: 'Password',
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FlexibleInputWidget(
                          hintText: 'Confirm your password',
                          topLabel: 'Confirm Password',
                          obscureText: _obscureConfirmPassword,
                          prefixIcon: Icons.lock,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  type: ButtonType.PLAIN,
                  onPressed: () {
                    nextScreen(context, "/home");
                  },
                  text: 'Registration',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Constants.activeMenu),
                    ),
                    TextButton(
                        onPressed: () {
                          nextScreen(context, '/login');
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                              color: Constants.activeMenu,
                              fontWeight: FontWeight.bold),
                        ))
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
