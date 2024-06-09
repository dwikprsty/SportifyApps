import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify_app/cubit/counter_cubit.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/utils/helper.dart';
import 'package:sportify_app/widgets/button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        backgroundColor: Constants.primaryColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<CounterCubit, CounterState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            color: Constants.primaryColor, // Background color of the whole screen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome with Cubit",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Here to demonstrate interaction flow with Cubit, update state counter in another screen, but it persists updated in welcome screen",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Constants.scaffoldBackgroundColor, // Set internal container color here
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                            width: double.infinity,
                          ),
                          Text(
                            '${state.counter}',
                            style: TextStyle(
                              fontSize: 40.0,
                              color: state.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Counter value from Counter-screen',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            state.status,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: state.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          AppButton(
                              type: ButtonType.PRIMARY,
                              onPressed: () {
                                nextScreen(context, '/counter');
                              },
                              text: 'Counter')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
