import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlopapp/core/storage/secure_storage_service.dart';
import 'package:otlopapp/features/profile/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://accessories-eshop.runasp.net/api/',
              ),
            ),
        super(ProfileInitial());

  final Dio _dio;

  Future<void> getProfileData() async {
    emit(ProfileLoading());

    try {
      final token = await SecureStorageService.readToken();

      final response = await _dio.get(
        'auth/me',
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        emit(ProfileLoaded(userModel: UserModel.fromJson(data)));
        return;
      }

      if (data is Map) {
        emit(
          ProfileLoaded(
            userModel: UserModel.fromJson(
              data.map((key, value) => MapEntry(key.toString(), value)),
            ),
          ),
        );
        return;
      }

      emit(ProfileFailure(errorMessage: 'Invalid profile response.'));
    } on DioException catch (e) {
      emit(
        ProfileFailure(
          errorMessage:
              e.response?.data?.toString() ?? e.message ?? 'Profile failed.',
        ),
      );
    } catch (_) {
      emit(ProfileFailure(errorMessage: 'Profile failed.'));
    }
  }
}
