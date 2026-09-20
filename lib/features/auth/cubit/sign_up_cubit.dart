import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/core/networking/api_consumer.dart';
import 'package:otlopapp/core/networking/api_error_handler.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final ApiConsumer apiConsumer;

  SignUpCubit({required this.apiConsumer}) : super(SignUpInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    emit(SignUpLoading());

    try {
      await apiConsumer.post(
        path: 'auth/register',
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      emit(SignUpSuccess());
    } on DioException catch (e) {
      emit(SignUpFailure(errorMessage: ApiErrorHandeler.handleError(e)));
    } catch (e) {
      emit(SignUpFailure(errorMessage: e.toString()));
    }
  }
}
