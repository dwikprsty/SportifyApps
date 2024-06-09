import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify_app/cubit/counter_cubit.dart';
import 'package:sportify_app/utils/constants.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counterCubit =
        BlocProvider.of<CounterCubit>(context); // Get the Cubit
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc - Cubit Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                return Text(
                  '${state.counter}',
                  style: const TextStyle(fontSize: 24.0),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Constants.primaryColor)),
                  onPressed: () => counterCubit.decrement(),
                  child: const Icon(
                    Icons.remove,
                    color: Constants.activeMenu,
                  ),
                ),
                const SizedBox(width: 20.0),
                // Increment button
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Constants.primaryColor)),
                  onPressed: () => counterCubit.increment(),
                  child: const Icon(
                    Icons.add,
                    color: Constants.activeMenu,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
