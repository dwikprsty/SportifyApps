import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify_app/cubit/auth/auth_cubit.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/utils/helper.dart';
import 'package:sportify_app/widgets/button.dart';
import 'package:sportify_app/widgets/form.dart';
import 'package:sportify_app/utils/secure_storage_util.dart';
import 'package:sportify_app/dto/login.dart';
import 'package:sportify_app/services/data_service.dart';

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

  Future<void> sendLogin(BuildContext context, AuthCubit authCubit) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await DataService.sendLoginData(email, password);
    if (response.statusCode == 200) {
      debugPrint("sending success");
      final data = jsonDecode(response.body);
      final loggedIn = Login.fromJson(data);
      await SecureStorageUtil.storage
          .write(key: tokenStoreName, value: loggedIn.accessToken);

      authCubit.login(loggedIn.accessToken);
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/home");
      }
      debugPrint(loggedIn.accessToken);
    } else {
      debugPrint("failed");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Login gagal. Silakan periksa email dan password Anda.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/login_page.png"),
                fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 280),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Text(
                "Please login into your account",
                style: TextStyle(color: Colors.white),
              ),
              Card(
                color: Constants.scaffoldBackgroundColor,
                elevation: 4,
                margin: const EdgeInsets.fromLTRB(25, 40, 25, 40),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      InputWidget(
                        controller: _emailController,
                        hintText: 'Input your email',
                        topLabel: 'Email',
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      InputWidget(
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
                      const SizedBox(
                        height: 10,
                      ),
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
              const SizedBox(height: 20),
              AppButton(
                type: ButtonType.PLAIN,
                onPressed: () {
                  sendLogin(context, authCubit);
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
                          fontWeight: FontWeight.bold),
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
