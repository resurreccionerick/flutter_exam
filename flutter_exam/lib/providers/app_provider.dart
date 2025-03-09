
import 'package:flutter/material.dart';
import 'package:flutter_exam/api/api_service.dart';
import 'package:flutter_exam/models/SocialsModel.dart';
import 'package:flutter_exam/models/UserModel.dart';

class ApiProvider with ChangeNotifier {
  final ApiService apiService;

  ApiProvider(this.apiService);

  String _username = '';
  String _pin = '';

  bool _isLoading = false;
  String _errorMessage = '';

  String _successMessage = '';
  bool _isEnterButtonEnabled = false;

  UserModel? _user;
  List<SocialsModel>? _socials;

  String get username => _username;
  String get pin => _pin;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  bool get isEnterButtonEnabled => _isEnterButtonEnabled;
  UserModel? get user => _user;
  List<SocialsModel>? get social => _socials;

   void setUsername(String value) {
    _username = value;
    _validateUsername(value);
    notifyListeners();
  }

  void setPin(String value) {
    _pin = value;
    notifyListeners();
  }

  void _validateUsername(String value) {
    if (value.isEmpty) {
      _errorMessage = 'Please enter your username.';
      _isEnterButtonEnabled = false;
    } else if (value.length > 24) {
      _errorMessage = 'Must not exceed 24 characters.';
      _isEnterButtonEnabled = false;
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      _errorMessage = 'Special characters are not allowed.';
      _isEnterButtonEnabled = false;
    } else {
      _errorMessage = '';
      _isEnterButtonEnabled = true;
    }
    notifyListeners();
  }

  bool validatePin(String pin) {
    final regex = RegExp(r'^\d{6}$');
    return regex.hasMatch(pin);
  }

  Future<void> login() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _user = await apiService.login(_username, _pin);
      print("USERNAME: $_username, PIN $_pin");
      if (_user != null && _user!.loginStatus.contains("success")) {
        _successMessage = 'Login successful!';
      } else {
        _errorMessage = 'Invalid username or PIN';
      }
    } catch (e) {
      _errorMessage = 'Failed to login: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(VoidCallback onLogoutComplete) async {
    _isLoading = true;
    _user = null;
    
    notifyListeners(); 

    await Future.delayed(const Duration(seconds: 3));

    _isLoading = false;
    _isEnterButtonEnabled = false;
    notifyListeners(); 

    onLogoutComplete();
  }

  Future<void> getSocials() async {
    _isLoading = true;
    notifyListeners(); // Show loading screen

    try {
      _socials = await apiService.getSocials();
      if (_user != null && _user!.loginStatus == 'success') {
        _successMessage = 'getSocials successful!';
      } else {
        _errorMessage = 'Something went wrong';
      }
    } catch (e) {
      _errorMessage = 'Failed to get socials: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}