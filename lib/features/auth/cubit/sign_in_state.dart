part of 'sign_in_cubit.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {
  final String errorMessage;

  SignInFailure({required this.errorMessage});
}
