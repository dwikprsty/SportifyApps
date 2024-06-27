import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sportify_app/dto/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitialState());

  void login(String accessToken, User dataUser) {
    emit(AuthState(isLoggedIn: true, accessToken: accessToken, dataUser: dataUser));
  }

  void logout() {
    emit(const AuthState(isLoggedIn: false, accessToken: "", dataUser: null));
  }

  void updateUser(User updatedUser) {
    final currentState = state;
    if (currentState.isLoggedIn) {
      emit(AuthState(
        isLoggedIn: true,
        accessToken: currentState.accessToken,
        dataUser: updatedUser,
      ));
    }
  }
}