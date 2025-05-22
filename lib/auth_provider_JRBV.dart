import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service_JRBV.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  String? _token;
  String? _error;

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get error => _error;

  Future<void> register(String username, String email, String password, 
    {String? gender, String? birthday}) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await _apiService.register(
      username, email, password, 
      gender: gender, 
      birthday: birthday
    );
    if (response.statusCode == 201) {
      _error = null;
    } else {
      final errorData = jsonDecode(response.body);
      _error = errorData['error']?.toString() ?? errorData['message']?.toString() ?? 'Registration failed';
    }
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'token', value: data['access']);
        _token = data['access'];
        _error = null;
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _error = errorData['error']?.toString() ?? errorData['message']?.toString() ?? 'Login failed';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'token');
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _token = null;
    notifyListeners();
  }
  
}
