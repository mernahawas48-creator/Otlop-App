import 'package:dio/dio.dart';

class AuthRepo {
  AuthRepo({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const String _baseUrl =
      'https://accessories-eshop.runasp.net/api/auth';

  Future<Response<dynamic>> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return _dio.post(
      '$_baseUrl/register',
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      },
    );
  }

  Future<Response<dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return _dio.post(
      '$_baseUrl/verify-email',
      data: {'email': email, 'otp': otp},
    );
  }

  Future<Response<dynamic>> signIn({
    required String email,
    required String password,
  }) {
    return _dio.post(
      '$_baseUrl/login',
      data: {'email': email, 'password': password},
    );
  }
}
