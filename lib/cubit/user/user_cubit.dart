import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify_app/cubit/user/user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState(isAdmin: false));

  void setAdmin(bool isAdmin) {
    emit(UserState(isAdmin: isAdmin));
  }
}