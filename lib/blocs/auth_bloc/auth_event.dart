part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
 final String fullName;
  final String userName;
  final String password;
  final String email;
  final String phone;

  SignUpEvent({
    required this.fullName,
    required this.userName,
    required this.password,
    required this.email,
    required this.phone,
  });
}

class LoginEvent extends AuthEvent {
  final String password;
  final String email;

  LoginEvent({
    required this.password,
    required this.email,
  });
}



class UpdatePasswordEvent extends AuthEvent {
  final String password;
  final String email;

  UpdatePasswordEvent({
    required this.password,
    required this.email,
  });
}


class UpdateProfileEvent extends AuthEvent {
  final File image;

  UpdateProfileEvent({
    required this.image,
  });
}

class SendOtpEvent extends AuthEvent {
  final String email;

  SendOtpEvent({
    required this.email,
  });
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String code;

  VerifyOtpEvent({
    required this.email,
    required this.code,
  });
}