import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sportify_app/dto/fields.dart';
import 'dart:convert';
import 'package:sportify_app/dto/register.dart';
import 'package:sportify_app/dto/reservation.dart';
import 'package:sportify_app/dto/session.dart';
import 'package:sportify_app/dto/user.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/utils/secure_storage_util.dart';

class DataService {
//Authentication
  static Future<bool> registerUser(Register registerData) async {
    var url = Uri.parse(Endpoints.register);
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'nama_pengguna': registerData.username,
      'email': registerData.email,
      'kata_sandi': registerData.password,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        // Registration successful
        debugPrint('Registration successful');
        return true;
      } else if (response.statusCode == 400) {
        // Handle validation errors or duplicate email
        var jsonResponse = json.decode(response.body);
        debugPrint('Registration failed: ${jsonResponse['msg']}');
        return false;
      } else {
        // Handle other errors
        debugPrint('Failed to register: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      // Handle network errors or exceptions
      debugPrint('Exception during registration: $e');
      return false;
    }
  }

  static Future<http.Response> sendLoginData(
      String email, String password) async {
    final url = Uri.parse(Endpoints.login);
    final data = {'email': email, 'kata_sandi': password};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }

  static Future<http.Response> logoutData() async {
    final url = Uri.parse(Endpoints.logout);
    final String? accessToken =
        await SecureStorageUtil.storage.read(key: 'access_token');
    debugPrint("logout with $accessToken");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    return response;
  }

//CRUD Fields
  static Future<List<FieldDetail>> fetchFields(int page, int pageSize) async {
  final response = await http.get(Uri.parse('${Endpoints.readField}?page=$page'));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['datas'];
    return data.map((item) => FieldDetail.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load fields');
  }
}

  static Future<void> createField(FieldDetail fieldDetail, File? galleryFile) async {
  final response = await http.post(
    Uri.parse(Endpoints.createField),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(fieldDetail.toJson()),
  );
  if (response.statusCode != 201) {
    throw Exception('Failed to create field');
  }
}


  static Future<void> updateField(FieldDetail fieldDetail) async {
    final response = await http.put(
      Uri.parse(Endpoints.updateField),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(fieldDetail.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update field');
    }
  }

  static Future<void> deleteField(String idLapangan) async {
    final url = Uri.parse('${Endpoints.deleteField}/$idLapangan');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete field: ${response.body}');
    }
  }

  static Future<List<Session>> fetchSessionTimes() async {
    final response = await http.get(Uri.parse(Endpoints.readSession));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['datas'];
      List<Session> sessionTimes =
          data.map((item) => Session.fromJson(item)).toList();

      return sessionTimes;
    } else {
      throw Exception('Failed to load session times');
    }
  }

//User
  static Future<User> fetchUser(String idPengguna) async {
    final response =
        await http.get(Uri.parse('${Endpoints.readUser}/$idPengguna'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)['datas'][0]);
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('${Endpoints.updateUser}/${user.idPengguna}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

//Reservation
  static Future<void> createReservation(Reservation reservation) async {
    final response = await http.post(
      Uri.parse(Endpoints.createReservation),
      body: reservation,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create reservation: ${response.body}');
    }
  }

  static Future<List<Reservation>> fetchBookingHistory(int id) async {
    final response = await http.get(Uri.parse(Endpoints.readReservation(id)));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      debugPrint(
          'fetchBookingHistory response: $responseBody'); // Tambahkan log disini
      final List<dynamic> data = responseBody['datas'];
      List<Reservation> bookingHistory = data.map((item) {
        return Reservation.fromJson(item);
      }).toList();

      return bookingHistory;
    } else {
      throw Exception('Failed to load booking history');
    }
  }

  static Future<FieldDetail?> fetchDetailLapangan(String id) async {
    final response = await http.get(Uri.parse(Endpoints.detailLapangan(id)));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      debugPrint(
          'fetchDetailLapangan response: $responseBody'); // Tambahkan log disini
      final Map<String, dynamic> data = responseBody['datas'];
      return data.isNotEmpty ? FieldDetail.fromJson(data) : null;
    } else {
      throw Exception('Failed to load field detail');
    }
  }

  static Future<Session?> fetchDetailSession(String id) async {
    final response = await http.get(Uri.parse(Endpoints.detailSesi(id)));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      debugPrint(
          'fetchDetailSession response: $responseBody'); // Tambahkan log disini
      final Map<String, dynamic> data = responseBody['datas'];
      return data.isNotEmpty ? Session.fromJson(data) : null;
    } else {
      throw Exception('Failed to load session detail');
    }
  }
}
