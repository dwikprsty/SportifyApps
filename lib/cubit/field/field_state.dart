import 'package:sportify_app/dto/fields.dart';

// Field state
class FieldState {
  final List<FieldDetail> listFieldDetail;

  FieldState({required this.listFieldDetail});
}

final class FieldInitial extends FieldState {
  FieldInitial() : super(listFieldDetail: []);
}
