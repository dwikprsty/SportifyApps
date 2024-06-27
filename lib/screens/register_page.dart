import 'package:flutter/material.dart';
import 'package:sportify_app/dto/register.dart';
import 'package:sportify_app/screens/config_screen.dart';
import 'package:sportify_app/services/data_service.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void registration() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Register registerData = Register(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    bool registrationSuccessful = await DataService.registerUser(registerData);
    if (registrationSuccessful) {
      navigation();
    } else {
      registrationFailed();
    }
  }

  void navigation() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  void registrationFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to register. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/register_page.png"),
                  fit: BoxFit.cover,
                ),
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
                        color: Colors.white,
                      ),
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
                            FlexibleInputWidget(
                              controller: _usernameController,
                              hintText: 'Create your username',
                              topLabel: 'Username',
                              prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 10),
                            FlexibleInputWidget(
                              controller: _emailController,
                              hintText: 'Example@domain.com',
                              topLabel: 'E-mail Address',
                              prefixIcon: Icons.mail,
                            ),
                            const SizedBox(height: 10),
                            FlexibleInputWidget(
                              controller: _passwordController,
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
                              controller: _confirmPasswordController,
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
                      onPressed: registration,
                      text: 'Register',
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
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              color: Constants.activeMenu,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConfigScreen()),
                  );
                },
                backgroundColor: Constants.activeMenu,
                child: const Icon(Icons.settings)),
          ),
        ],
      ),
    );
  }
}
