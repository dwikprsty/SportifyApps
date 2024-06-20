import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify_app/cubit/field/field_state.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/services/data_service.dart';

class FieldCubit extends Cubit<FieldState> {
  FieldCubit() : super(FieldInitial());

  void fetchField() async {
    debugPrint('Processing field data..');
    DataService dataService = DataService();
    List<FieldDetail> listField;
    listField = await dataService.fetchFields();
    emit(FieldState(listFieldDetail: listField));
  }
}
