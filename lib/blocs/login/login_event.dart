/*

@author         : karthick.d  on 07/05/2025
@description    : class - LoginEvent , defines event sets for Login
LoginInit , LoginSuccess , LoginError are the possible events for Login feature

 */

/*
 to import  sealed class in another package or class must be include part of keyword so this class
can be imported in anothe file like part 'login_event' - refer login_bloc.dart
*/
part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

// when login page loaded button in login page - login initiated event dispatched
// set the initial data and login state=us to init

final class LoginInit extends LoginEvent {}

// on login button clicked Loginfetch event is dispatched
// status is changed to fetch
final class LoginFetch extends LoginEvent {
  final LoginRequest loginRequest;
  const LoginFetch({required this.loginRequest});
}

final class LoginPasswordSecure extends LoginEvent {}

// when click login api  responded in login page - LoginSuccess event dispatched

final class LoginSuccess extends LoginEvent {}

// when click login api  responded with error - LoginError event dispatched

final class LoginError extends LoginEvent {}

// wehn click passwrodSecure event password will be vissible or Hidden

final class LoginSecurePassword extends LoginEvent {}
