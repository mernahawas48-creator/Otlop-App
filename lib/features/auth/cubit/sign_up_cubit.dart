import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/core/networking/api_consumer.dart';
import 'package:meta/meta.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final ApiConsumer apiConsumer;
  SignUpCubit({required this.apiConsumer}) : super(SignUpInitial());
  signUp({
    required String email,
    required String password,
    required String firstname,
    required String lastname,
  }) async {
    emit(SignUpLoading());
    try {
      Response response = await apiConsumer.post(
        path: 'auth/sign-up',
        data: {
          'email': email,
          'password': password,
          'firstname': firstname,
          'lastname': lastname,
        },
      );
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(message: e.toString()));
    }
  }
}
