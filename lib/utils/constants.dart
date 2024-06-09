import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants {
  static const Color primaryColor = Color(0xFF1a4454);
  static const Color scaffoldBackgroundColor = Color(0xFFF3F7F8);
  static const Color activeMenu = Color(0xFFd8edf0);
  static const Color secondaryColor = Color(0xFF355c6e);
}

final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
final DateFormat formatDate = DateFormat('yyyy-MM-dd H:mm');
const tokenStoreName = "access_token";


