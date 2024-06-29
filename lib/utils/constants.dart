import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants {
  static const Color primaryColor = Color(0xFF1a4454);
  static const Color scaffoldBackgroundColor = Color(0xFFF3F7F8);
  static const Color activeMenu = Color(0xFFd8edf0);
  static const Color secondaryColor = Color(0xFF355c6e);
}

final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'IDR ');
// FormatException (FormatException: Trying to read yyyy from Sat, 29 Jun 2024 00:00:00 GMT at 0)
final DateFormat formatDate = DateFormat('yyyy-MM-dd');
final DateFormat formatDate2 = DateFormat('EEE, d MMM yyyy HH:mm:ss \'GMT\'');
// const tokenStoreName = "access_token";


