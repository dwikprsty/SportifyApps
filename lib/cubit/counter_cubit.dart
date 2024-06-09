import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterInitialState());

  String getStatus(int newCounter) {
    return newCounter % 2 == 0 ? 'Genap' : 'Ganjil';
  }

  Color getColor(int newCounter) {
    return newCounter % 2 == 0 ? Color.fromARGB(255, 255, 0, 89) : Colors.amber;
  }

  void increment() {
    final int newCounter = state.counter + 1;
    final String newStatus = getStatus(newCounter);
    final Color newColor = getColor(newCounter);
    emit(CounterState(counter: newCounter, status: newStatus, color: newColor));
  }

  void decrement() {
    final int newCounter = state.counter - 1;
    final String newStatus = getStatus(newCounter);
    final Color newColor = getColor(newCounter);
    emit(CounterState(counter: newCounter, status: newStatus, color: newColor));
  }

  void status() {}
}
