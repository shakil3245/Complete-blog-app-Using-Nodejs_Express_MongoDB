import 'dart:convert';
import 'dart:io';
import 'package:blogapp/Src/Services/apiServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import '../Models/profileModel.dart';

class ProfileProvider extends ChangeNotifier {
  Profile? _profile;
  bool _isLoading = false;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;

  //

  Future<void> fetchProfile({bool forceRefresh = false}) async {
    // 🔒 Guard: don’t call API again
    if (_profile != null && !forceRefresh) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService().fetchProfileData();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _profile = Profile.fromJson(data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }
  //
  // Future<void> fetchProfile() async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     final response = await ApiService().fetchProfileData();
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       _profile = Profile.fromJson(data);
  //     } else {
  //       throw Exception('Failed to load profile');
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }



  //update profile
  Future<void> updateProfile({
    required String name,
    required String bio,
    File? avatar,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await ApiService.updateProfile(
        name: name,
        bio: bio,
        avatar: avatar,
      );

      if (response == null) {
        Get.snackbar("Error", "Network error");
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      } else {
        Get.snackbar("Error", data['message'] ?? "Update failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
