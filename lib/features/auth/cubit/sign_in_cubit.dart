import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:otlopapp/core/networking/api_consumer.dart';
import 'package:otlopapp/core/networking/api_error_handler.dart';
import 'package:otlopapp/core/storage/secure_storage_service.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required this.apiConsumer}) : super(SignInInitial());

  final ApiConsumer apiConsumer;

  Future<void> signIn({required String email, required String password}) async {
    emit(SignInLoading());

    try {
      final response = await apiConsumer.post(
        path: 'auth/login',
        data: {'email': email, 'password': password},
      );

      final token = _extractToken(response.data);

      if (token != null && token.isNotEmpty) {
        await SecureStorageService.saveToken(token);
      }

      emit(SignInSuccess());
    } on DioException catch (e) {
      final errorMessage = ApiErrorHandeler.handleError(e);

      if (errorMessage.toLowerCase().contains('email not verified')) {
        emit(SignInSuccess());
        return;
      }

      emit(SignInFailure(errorMessage: errorMessage));
    } catch (_) {
      emit(
        SignInFailure(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  String? _extractToken(dynamic data) {
    if (data is! Map) {
      return null;
    }

    const tokenKeys = ['token', 'accessToken', 'access_token', 'jwt'];

    for (final key in tokenKeys) {
      final value = data[key];

      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    for (final key in ['data', 'result']) {
      final nestedToken = _extractToken(data[key]);

      if (nestedToken != null) {
        return nestedToken;
      }
    }

    return null;
  }
}
