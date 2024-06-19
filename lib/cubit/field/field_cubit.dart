import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify_app/cubit/field/field_state.dart';
import 'package:sportify_app/dto/fields.dart';

class FieldCubit extends Cubit<FieldState> {
  FieldCubit(FieldDetail initialFieldDetail) : super(FieldState(fieldDetail: initialFieldDetail));

  void updateField(FieldDetail newFieldDetail) {
    emit(FieldState(fieldDetail: newFieldDetail));
  }
}