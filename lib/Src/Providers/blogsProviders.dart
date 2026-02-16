import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../Models/blogsModel.dart';
import '../Services/apiServices.dart';


class BlogProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<BlogPost> _posts = [];
  bool _isLoading = false;

  List<BlogPost> get posts => _posts;
  bool get isLoading => _isLoading;

  //get blogs
  Future<void> getBlogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchData();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List postList = data['posts'];

        _posts = postList
            .map((post) => BlogPost.fromJson(post))
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching blogs: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
//Delete Blogs
  Future<void> deletePost(String id) async {
    try {
      final response = await _apiService.deletePost(id);

      if (response.statusCode == 200 || response.statusCode == 204) {
        posts.removeWhere((posts) => posts.id.toString() == id);
        notifyListeners();
        Get.snackbar('Success', 'Post deleted successfully');
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Error', error['message'] ?? 'Failed to delete post');
      }
    } catch (err) {
      Get.snackbar('Error', err.toString());
    }
  }



}
