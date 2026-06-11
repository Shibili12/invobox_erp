import 'package:flutter/material.dart';

enum LoginStatus { idle, loading, success, error }

class LoginController extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String _domain = 'gulfdirecttest.com';
  bool _rememberMe = true;
  bool _obscurePassword = true;
  LoginStatus _status = LoginStatus.idle;
  String _errorMessage = '';

  String get domain => _domain;
  bool get rememberMe => _rememberMe;
  bool get obscurePassword => _obscurePassword;
  LoginStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == LoginStatus.loading;

  void setDomain(String value) {
    _domain = value;
    notifyListeners();
  }

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = 'Please enter username and password';
      _status = LoginStatus.error;
      notifyListeners();
      return false;
    }

    _status = LoginStatus.loading;
    _errorMessage = '';
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Demo: accept any credentials
    _status = LoginStatus.success;
    notifyListeners();
    return true;
  }

  void reset() {
    _status = LoginStatus.idle;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
