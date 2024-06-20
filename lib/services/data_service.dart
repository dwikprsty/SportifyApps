import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sportify_app/dto/fields.dart';
import 'dart:convert';
import 'package:sportify_app/dto/register.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/utils/secure_storage_util.dart';

class DataService {
  Future<bool> registerUser(Register registerData) async {
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
        print('Registration successful');
        return true;
      } else if (response.statusCode == 400) {
        // Handle validation errors or duplicate email
        var jsonResponse = json.decode(response.body);
        print('Registration failed: ${jsonResponse['msg']}');
        return false;
      } else {
        // Handle other errors
        print('Failed to register: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Exception during registration: $e');
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

  Future<List<FieldDetail>> fetchFields() async {
    final response = await http.get(Uri.parse(Endpoints.readField));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['datas'];
      return data.map((item) => FieldDetail.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load fields');
    }
  }

  Future<void> createField(FieldDetail fieldDetail) async {
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
    final response = await http.delete(Uri.parse(Endpoints.deleteField));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete field');
    }
  }

}
