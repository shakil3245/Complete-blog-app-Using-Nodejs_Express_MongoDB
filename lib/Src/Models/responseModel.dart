class LoginResponseModel {
  final String token;
  final String role;

  LoginResponseModel({required this.token, required this.role});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      role: json['user']['role'],
    );
  }
}