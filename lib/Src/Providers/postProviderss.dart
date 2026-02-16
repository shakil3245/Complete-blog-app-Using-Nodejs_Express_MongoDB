import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Models/blogsModel.dart';
import '../Models/fetchBlogModel.dart';
import '../Services/apiServices.dart';
import '../Services/tokenStorage.dart';

class PostProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();


  bool isLoading = false;
  var blogsList = [];


  Future<void> getPosts() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await apiService.fetchData();

      if (response.statusCode == 200) {
        blogsList = fetchBlogModelFromJson(response.body) as List<dynamic>;
      } else {
        Get.snackbar('Error', 'Data fetch error');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  //
  // Future<void> createPost({
  //   required String title,
  //   required String body,
  //   required List<String> categories,
  //   required List<String> tags,
  //   required File image,
  // }) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //
  //     final response = await ApiService.createPost(
  //       title: title,
  //       body: body,
  //       categories: categories.join(","), // send as string
  //       tags: tags.join(","),             // send as string
  //       image: image,
  //     );
  //
  //     if (response == null) {
  //       Get.snackbar("Error", "Network error");
  //       return;
  //     }
  //
  //     final data = jsonDecode(response.body);
  //
  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       Get.snackbar(
  //         "Success",
  //         "Post created successfully",
  //         snackPosition: SnackPosition.BOTTOM,
  //         duration: const Duration(seconds: 2),
  //       );
  //       Future.delayed(const Duration(seconds: 2), () {
  //         Get.back();
  //       });
  //
  //     } else {
  //       Get.snackbar("Error", data['message'] ?? "Post creation failed");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }


  Future<void> createPost({
    required String title,
    required String body,
    required List<String> categories,
    required List<String> tags,
    required File image,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await ApiService.createPost(
        title: title,
        body: body,
        categories: categories.join(","), // or send as list if API expects JSON array
        tags: tags.join(","),
        image: image,
      );

      if (response == null) {
        Get.snackbar("Error", "Network error");
        return;
      }

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Post created successfully",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        // Delayed navigation if needed
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      } else {
        Get.snackbar("Error", data['message'] ?? "Post creation failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}
