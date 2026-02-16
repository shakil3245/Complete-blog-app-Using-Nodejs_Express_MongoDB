import 'package:blogapp/Src/Models/profileModel.dart';

class AppConstants {
  static const baseUrl = "https://blog-app-api-nodejs-expresss-mongodb.onrender.com";
  static const register = "/api/auth/register";
  static const login = "/api/auth/login";
  static const Profile = "/api/users/me";
  static const blogs = "/api/posts";
  static const search = "/api/posts/search";
  static const CreatePost = "/api/posts";
  static const UpdateProfile = "/api/users/me";
}