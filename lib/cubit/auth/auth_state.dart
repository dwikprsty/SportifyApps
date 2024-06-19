part of 'auth_cubit.dart';

@immutable
class AuthState {
  final bool isLoggedIn;
  final String? accessToken;
  final User? dataUser;
  const AuthState({required this.isLoggedIn, this.accessToken, this.dataUser});
}

final class AuthInitialState extends AuthState {
  const AuthInitialState() : super(isLoggedIn: true, accessToken: " ", dataUser: null);
}
