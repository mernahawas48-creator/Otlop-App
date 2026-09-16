import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:otlopapp/core/networking/api_error_handler.dart';
import 'package:otlopapp/core/storage/secure_storage_service.dart';
import 'package:otlopapp/features/auth/repos/auth_repo.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({AuthRepo? authRepo})
    : _authRepo = authRepo ?? AuthRepo(),
      super(SignInInitial());

  final AuthRepo _authRepo;

  Future<void> signIn({required String email, required String password}) async {
    emit(SignInLoading());

    try {
      final response = await _authRepo.signIn(email: email, password: password);

      final token = _extractToken(response.data);

      if (token != null && token.isNotEmpty) {
        await SecureStorageService.saveToken(token);
      }

      // Normal successful login
      emit(SignInSuccess());
    } on DioException catch (e) {
      final errorMessage = ApiErrorHandeler.handleError(e);

      // The backend refuses unverified emails.
      // For this project we allow the user to enter Home
      // when this is the only problem.
      if (errorMessage.toLowerCase().contains('email not verified')) {
        emit(SignInSuccess());
        return;
      }

      // Any other error:
      // wrong email, wrong password, server error, etc.
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
