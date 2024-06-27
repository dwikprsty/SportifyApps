import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sportify_app/dto/fields.dart';
import 'dart:convert';
import 'package:sportify_app/dto/register.dart';
import 'package:sportify_app/dto/reservation.dart';
import 'package:sportify_app/dto/user.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/utils/secure_storage_util.dart';

class DataService {
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

  static Future<List<FieldDetail>> fetchFields() async {
    final response = await http.get(Uri.parse(Endpoints.readField));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['datas'];
      return data.map((item) => FieldDetail.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load fields');
    }
  }

  static Future<void> createField(FieldDetail fieldDetail) async {
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

  static Future<void> createReservation(Reservation reservation) async {
    final response = await http.post(
      Uri.parse(Endpoints.createReservation),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reservation.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create reservation');
    }
  }

  static Future<List<String>> fetchSessionTimes() async {
    final response = await http.get(Uri.parse(Endpoints.readSession));

    if (response.statusCode == 200) {
      final List sessions = json.decode(response.body)['datas'];
      return sessions
          .map<String>((session) => session['waktu'] as String)
          .toList();
    } else {
      throw Exception('Failed to load session times');
    }
  }

  static Future<User> fetchUser() async {
    final response = await http.get(Uri.parse(Endpoints.readUser));

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

  // static Future<void> updateUser(User user) async {
  //   final response = await http.put(
  //     Uri.parse('${Endpoints.updateUser}/${user.idPengguna}'),
  //     body: {
  //       'jenis_pengguna': user.isAdmin ? 'admin' : 'user',
  //       'nama_pengguna': user.namaPengguna,
  //       'email': user.email,
  //       'nickname': user.nickname,
  //       'alamat': user.alamat,
  //       'jenis_kelamin': user.jenisKelamin,
  //       'tgl_lahir': user.tglLahir.toIso8601String(),
  //       'no_telp': user.noTelp,
  //     },
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to update user');
  //   }
  // }

  // static Future<User> fetchUser() async {
  //   final response = await http.get(Uri.parse(Endpoints.readUser));

  //   if (response.statusCode == 200) {
  //     return User.fromJson(json.decode(response.body)['datas']
  //         [0]); // Sesuaikan dengan struktur response
  //   } else {
  //     throw Exception('Failed to load user');
  //   }
  // }

  // static Future<User> createUser(User user) async {
  //   final response = await http.post(
  //     Uri.parse(Endpoints.createUser),
  //     body: {
  //       'id_pengguna': user.idPengguna.toString(),
  //       'jenis_pengguna': user.isAdmin ? 'admin' : 'user',
  //       'nama_pengguna': user.namaPengguna,
  //       'email': user.email,
  //       'nickname': user.nickname,
  //       'alamat': user.alamat,
  //       'jenis_kelamin': user.jenisKelamin,
  //       'tgl_lahir': user.tglLahir.toIso8601String(),
  //       'no_telp': user.noTelp,
  //     },
  //   );

  //   if (response.statusCode == 201) {
  //     return User.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to create user');
  //   }
  // }

  // // data_service.dart
  // static Future<void> updateUser(User user) async {
  //   final response = await http.put(
  //     Uri.parse('${Endpoints.updateUser}/${user.idPengguna}'),
  //     body: {
  //       'jenis_pengguna': user.isAdmin ? 'admin' : 'user',
  //       'nama_pengguna': user.namaPengguna,
  //       'email': user.email,
  //       'nickname': user.nickname,
  //       'alamat': user.alamat,
  //       'jenis_kelamin': user.jenisKelamin,
  //       'tgl_lahir': user.tglLahir.toIso8601String(),
  //       'no_telp': user.noTelp,
  //     },
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to update user');
  //   }
  // }

  // static Future<void> deleteUser(String id) async {
  //   final response = await http.delete(Uri.parse(Endpoints.deleteUser));

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to delete user');
  //   }
  // }
}
