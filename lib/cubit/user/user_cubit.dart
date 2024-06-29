import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify_app/dto/user.dart';
import 'package:sportify_app/services/data_service.dart'; // Pastikan import sudah benar

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final DataService dataService;

  UserCubit(this.dataService) : super(UserInitial());

  Future<void> fetchUser() async {
    try {
      emit(UserLoading());
      // final user = await DataService.fetchUser();
      // emit(UserLoaded(user));
    } catch (e) {
      emit(const UserError("Failed to fetch user"));
    }
  }

  Future<void> updateUser(User user) async {
    try {
      emit(UserLoading());
      await DataService.updateUser(user); // Gunakan instance dataService
      emit(UserUpdated());
      fetchUser();
    } catch (e) {
      emit(const UserError("Failed to update user"));
    }
  }
}
