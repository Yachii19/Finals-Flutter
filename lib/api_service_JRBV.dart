import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<http.Response> register(String username, String email, String password, 
      {String? gender, String? birthday}) async {
    return await http.post(
      Uri.parse('${baseUrl}register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'gender': gender,
        'birthday': birthday,
      }),
    );
  }

  Future<http.Response> login(String username, String password) async {
    return await http.post(
      Uri.parse('${baseUrl}login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
  }

  Future<http.Response> getProfile(String token) async {
    return await http.get(
      Uri.parse('${baseUrl}profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> getUserList(String token) async {
    return await http.get(
      Uri.parse('${baseUrl}users/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}