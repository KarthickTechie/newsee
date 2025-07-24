part of 'auth_bloc.dart';

sealed class AuthEvent {}

// bloc event type that will be called when Login button clicked
final class LoginWithAccount extends AuthEvent {
  final LoginRequest loginRequest;

  LoginWithAccount({required this.loginRequest});
}

final class PasswordSecure extends AuthEvent {}

class LogoutRequested extends AuthEvent {
  List<Object?> get props => [];
}

