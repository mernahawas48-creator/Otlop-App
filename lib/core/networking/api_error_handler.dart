import 'package:dio/dio.dart';
import 'package:otlopapp/core/networking/error_model.dart';

class ApiErrorHandeler {
  static String handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.badResponse:
        return _handleBadResponse(e);
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timed out. Please try again later.';
      case DioExceptionType.connectionError:
        return 'Unable to connect to the server. Check your internet connection.';
      case DioExceptionType.cancel:
        return 'Request was cancelled. Please try again.';
      case DioExceptionType.badCertificate:
        return 'A secure connection could not be established.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static String _handleBadResponse(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final errorModel = ErrorModel.fromJson(data);
      if (errorModel.errors.isNotEmpty) {
        return errorModel.errors.join('\n');
      }
      return errorModel.message;
    }

    if (data is Map) {
      final converted = data.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      final errorModel = ErrorModel.fromJson(converted);
      return errorModel.errors.join('\n');
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    switch (e.response?.statusCode) {
      case 401:
        return 'Incorrect email or password.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 500:
        return 'Internal server error. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
