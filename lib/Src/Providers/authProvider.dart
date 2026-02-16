import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../Screens/Admin/AdminHomeScreen/adminScreen.dart';
import '../Screens/Auth_Screens/loginScreen.dart';
import '../Screens/BottomNavigation/bottomNavigationBar.dart';
import '../Services/apiServices.dart';
import '../Services/tokenStorage.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String role = '';

  /// REGISTER USER / ADMIN
  Future<void> registerUser(
      String name, String email, String password, String role) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {};
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Registration successful");
        Get.offAll(() => LoginScreen());
      } else {
        Get.snackbar("Error", data['message'] ?? "Registration failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// LOGIN USER / ADMIN
  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await ApiService.login(email, password);

      if (result != null) {
        await Storage.saveAuth(result.token, result.role);
        role = result.role;

        if (result.role == 'admin') {
          Get.offAll(() => AdminScreen());
        } else {
          Get.offAll(() => BottomNavExample());
        }
      } else {
        Get.snackbar("Error", "Invalid credentials");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// CHECK LOGIN AND ROLE
  bool _hasCheckedLogin = false;

  Future<void> checkLogin() async {
    if (_hasCheckedLogin) return; // prevent multiple calls
    _hasCheckedLogin = true;

    final token = await Storage.getToken();
    final savedRole = await Storage.getRole();

    if (token != null && savedRole != null) {
      role = savedRole;
      if (savedRole == 'admin') {
        Get.offAll(() => AdminScreen());
      } else {
        Get.offAll(() => BottomNavExample());
      }
    } else {
      Get.offAll(() => LoginScreen());
    }
  }


  /// LOGOUT USER
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    role = '';
    Get.offAll(() => LoginScreen());
    notifyListeners();
  }
}
