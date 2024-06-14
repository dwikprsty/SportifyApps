import 'package:flutter/material.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/utils/helper.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/flexible_form_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: deviceWidth,
          height: deviceHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_page.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: deviceHeight * 0.35),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Please login into your account",
                style: TextStyle(color: Colors.white),
              ),
              Card(
                color: Constants.scaffoldBackgroundColor,
                elevation: 4,
                margin: EdgeInsets.fromLTRB(
                  deviceWidth * 0.08,
                  deviceHeight * 0.05,
                  deviceWidth * 0.08,
                  deviceHeight * 0.05,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      FlexibleInputWidget(
                        controller: _emailController,
                        hintText: 'Input your email',
                        topLabel: 'Email',
                        prefixIcon: Icons.email,
                      ),
                      SizedBox(height: deviceHeight * 0.02),
                      FlexibleInputWidget(
                        controller: _passwordController,
                        hintText: 'Input your password',
                        topLabel: 'Password',
                        obscureText: _isObscure,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                rememberMe = !rememberMe;
                              });
                            },
                            child: Icon(
                              rememberMe
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: Constants.secondaryColor,
                            ),
                          ),
                          const Text("Remember me"),
                          const Spacer(),
                          const Text(
                            "Forgot password",
                            style: TextStyle(color: Constants.secondaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),
              AppButton(
                type: ButtonType.PLAIN,
                onPressed: () {
                  nextScreen(context, '/home');
                },
                text: 'Log In',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Constants.activeMenu),
                  ),
                  TextButton(
                    onPressed: () {
                      nextScreen(context, '/register');
                    },
                    child: const Text(
                      "Sign Up",
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
    );
  }
}
