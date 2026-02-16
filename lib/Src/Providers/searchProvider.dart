import 'dart:async';
import 'dart:convert';
import 'package:blogapp/Src/Utils/appConstants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/fetchBlogModel.dart';
import '../Models/searchModel.dart';


class SearchProvider with ChangeNotifier {
  List<SearchModel> _posts = [];
  bool _isLoading = false;
  Timer? _debounce;

  List<SearchModel> get posts => _posts;
  bool get isLoading => _isLoading;

  /// Call this when the text field changes
  void onSearchChanged(String query) {
    // Cancel previous debounce
    _debounce?.cancel();

    if (query.isEmpty) {
      // Clear posts if input empty
      _posts = [];
      notifyListeners();
      return;
    }

    // Debounce API call by 500ms
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchPosts(query);
    });
  }

  Future<void> searchPosts(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Replace localhost for emulator if needed
      final url =
      Uri.parse('${AppConstants.baseUrl}/api/posts/search?category=$category');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List postsJson = data['posts'];
        _posts = postsJson.map((e) => SearchModel.fromJson(e)).toList();
      } else {
        _posts = [];
      }
    } catch (e) {
      _posts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
