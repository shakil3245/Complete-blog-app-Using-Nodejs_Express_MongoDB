import 'dart:convert';
import 'dart:io';

import 'package:blogapp/Src/Services/tokenStorage.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

import '../Models/blogsModel.dart';
import '../Models/fetchBlogModel.dart';
import '../Models/responseModel.dart';
import '../Utils/appConstants.dart';

class ApiService {
  // registration user

  static Future<http.Response> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final apiUrl = Uri.parse("${AppConstants.baseUrl + AppConstants.register}");

    return await http.post(
      apiUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      }),
    );
  }

  //login

  static Future<LoginResponseModel?> login(
    String email,
    String password,
  ) async {
    final apiUrl = Uri.parse("${AppConstants.baseUrl + AppConstants.login}");
    final response = await http.post(
      apiUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponseModel.fromJson(data);
    } else {
      return null;
    }
  }

  //Fetch Data

  Future<http.Response> fetchData() async {
    final token = await Storage.getToken();
    return await http.get(
      Uri.parse("${AppConstants.baseUrl + AppConstants.blogs}"),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  //post data
  Future<http.Response> postData(String title, String description) async {
    final token = await Storage.getToken();
    final url = Uri.parse('${AppConstants.baseUrl}/api/journals');

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'content': description}),
    );
  }

  //delete data
  Future<http.Response> deletePost(String postId) async {
    final token = await Storage.getToken();
    final url = Uri.parse('${AppConstants.baseUrl}/api/posts/$postId');

    return await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
    );
  }

  //profile data
  Future<http.Response> fetchProfileData() async {
    final token = await Storage.getToken();
    return await http.get(
      Uri.parse("${AppConstants.baseUrl + AppConstants.Profile}"),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  //search blogs
  Future<List<Post>> searchPosts({
    String? keyword,
    String? category,
    String? tag,
    String? author,
    String? sortBy,
    String? fromDate,
    String? toDate,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, String>{};

    if (keyword != null) queryParams['keyword'] = keyword;
    if (category != null) queryParams['category'] = category;
    if (tag != null) queryParams['tag'] = tag;
    if (author != null) queryParams['author'] = author;
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (fromDate != null) queryParams['fromDate'] = fromDate;
    if (toDate != null) queryParams['toDate'] = toDate;
    queryParams['page'] = page.toString();
    queryParams['limit'] = limit.toString();
    final apiUrl = Uri.parse(
      "${AppConstants.baseUrl + AppConstants.search}",
    ).replace(queryParameters: queryParams);
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['posts'] as List).map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }




  //post blog

  static Future<http.Response?> createPost({
    required String title,
    required String body,
    required String categories, // comma separated
    required String tags,       // comma separated
    required File image,
  }) async {
    try {
      final token = await Storage.getToken();
      var uri = Uri.parse(AppConstants.baseUrl + AppConstants.CreatePost);
      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      // plain text fields
      request.fields['title'] = title;
      request.fields['body'] = body;
      request.fields['categories'] = categories; // comma separated string
      request.fields['tags'] = tags;             // comma separated string

      // only image file
      // request.files.add(
      //   await http.MultipartFile.fromPath(
      //     'image',
      //     image.path,
      //     contentType: http.MediaType('image', 'jpeg'),
      //   ),
      // );

      final mimeType = lookupMimeType(image.path); // 👈 IMPORTANT

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: http.MediaType.parse(mimeType!), // 👈 FIX
        ),
      );

      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      return null;
    }
  }


  //update profile
  static Future<http.Response?> updateProfile({
    required String name,
    required String bio,
    File? avatar,
  }) async {
    try {
      final token = await Storage.getToken();

      final request = http.MultipartRequest(
        "PUT",
        Uri.parse(AppConstants.baseUrl+AppConstants.UpdateProfile),
      );

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields['name'] = name;
      request.fields['bio'] = bio;

      if (avatar != null) {
        final mimeType = lookupMimeType(avatar.path); // 👈 IMPORTANT

        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            avatar.path,
            contentType: http.MediaType.parse(mimeType!), // 👈 FIX
          ),
        );
      }

      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      return null;
    }
  }
}
