import 'package:dio/dio.dart';

class ApiConsumer {
  // BASE URL

  Dio dio = Dio(
    BaseOptions(baseUrl: 'https://accessories-eshop.runasp.net/api/'),
  );

  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response = await dio.get(path, queryParameters: queryParameters);
    return response;
  }

  Future<Response> post({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    Response response = await dio.post(path, data: data);
    return response;
  }

  // Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) async {
  //   try {
  //     Response response = await dio.get(url, queryParameters: queryParameters);
  //     return response;
  //   } catch (e) {
  //     throw Exception('Failed to load data: $e');
  //   }
  // }

  // Future<Response> post(String url, {Map<String, dynamic>? data}) async {
  //   try {
  //     Response response = await dio.post(url, data: data);
  //     return response;
  //   } catch (e) {
  //     throw Exception('Failed to post data: $e');
  //   }
  // }
}
