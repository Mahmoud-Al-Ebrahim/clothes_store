part of 'auth_bloc.dart';

enum LoginStatus { init, loading, success, failure }

enum CreateAccountStatus { init, loading, success, failure }

enum UserInfoStatus { init, loading, success, failure }

enum SendOtpStatus { init, loading, success, failure }

enum VerifyOtpStatus { init, loading, success, failure }

enum ResetPasswordStatus { init, loading, success, failure }

enum UpdateProfileStatus { init, loading, success, failure }

class AuthState {
  const AuthState({
    this.loginStatus = LoginStatus.init,
    this.createAccountStatus = CreateAccountStatus.init,
    this.userInfoStatus = UserInfoStatus.init,
    this.sendOtpStatus = SendOtpStatus.init,
    this.verifyOtpStatus = VerifyOtpStatus.init,
    this.resetPasswordStatus = ResetPasswordStatus.init,
    this.updateProfileStatus = UpdateProfileStatus.init,
    this.errorMessage
  });

  final LoginStatus loginStatus;

  final CreateAccountStatus createAccountStatus;

  final UserInfoStatus userInfoStatus;

  final SendOtpStatus sendOtpStatus;

  final VerifyOtpStatus verifyOtpStatus;

  final ResetPasswordStatus resetPasswordStatus;

  final UpdateProfileStatus updateProfileStatus;

  final String? errorMessage;

  AuthState copyWith(
  {
    LoginStatus? loginStatus,
    CreateAccountStatus? createAccountStatus,
    final UserInfoStatus? userInfoStatus,
    final SendOtpStatus? sendOtpStatus,

    final VerifyOtpStatus? verifyOtpStatus,

    final ResetPasswordStatus? resetPasswordStatus,

    final UpdateProfileStatus? updateProfileStatus,
    String? errorMessage
}
      ){
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      createAccountStatus: createAccountStatus ?? this.createAccountStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      userInfoStatus: userInfoStatus ?? this.userInfoStatus,
      sendOtpStatus: sendOtpStatus ?? this.sendOtpStatus,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
      updateProfileStatus: updateProfileStatus ?? this.updateProfileStatus,
    );
  }
}
