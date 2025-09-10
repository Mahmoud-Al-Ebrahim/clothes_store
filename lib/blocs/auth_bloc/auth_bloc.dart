import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clothes_store/models/auth_response_model.dart';

import '../../utils/api_service.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthEvent>((event, emit) {});
    on<SignUpEvent>(_onSignUpEvent);
    on<LoginEvent>(_onLoginEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
    on<UpdatePasswordEvent>(_onUpdatePasswordEvent);
    on<SendOtpEvent>(_onSendOtpEvent);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
  }

  AuthResponseModel? userModel;

  saveUser(
    String token,
    String email,
    String fullName,
    String userName,
    String phone,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('token', token);
    sharedPreferences.setString('email', email);
    sharedPreferences.setString('fullName', fullName);
    sharedPreferences.setString('userName', userName);
    sharedPreferences.setString('phone', phone);
  }

  FutureOr<void> _onSignUpEvent(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(createAccountStatus: CreateAccountStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Auth/SignUp',
          body: {
            'repeatPassword': event.password,
            'password': event.password,
            'email': event.email,
            'fullName': event.fullName,
            'userName': event.userName,
            'phone': event.phone,
          },
        )
        .then((response) {
          print(response.data);
          userModel = AuthResponseModel.fromJson(response.data);
          saveUser(
            userModel!.accessToken!,
            event.email,
            event.fullName,
            event.userName,
            event.phone,
          );
          ApiService.init();
          emit(
            state.copyWith(createAccountStatus: CreateAccountStatus.success),
          );
        })
        .catchError((error) {
          print(error);
          emit(
            state.copyWith(
              createAccountStatus: CreateAccountStatus.failure,
              errorMessage: error.response.data['message'],
            ),
          );
        })
        .onError((error, stackTrace) {
          print(error);
          emit(
            state.copyWith(
              createAccountStatus: CreateAccountStatus.failure,
              errorMessage: "Something went wrong!",
            ),
          );
        });
  }

  FutureOr<void> _onLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    print(event.email);
    print(event.password);
    await ApiService.postMethod(
          endPoint: 'Auth/Login',
          body: {'password': event.password, 'email': event.email},
        )
        .then((response) {
          print(response.data);
          userModel = AuthResponseModel.fromJson(response.data);
          saveUser(
            userModel!.accessToken!,
            event.email,
            userModel!.user!.fullName!,
            userModel!.user!.userName!,
            userModel!.user!.phone!,
          );
          ApiService.init();
          emit(state.copyWith(loginStatus: LoginStatus.success));
        })
        .catchError((error) {
          print(error);
          print(error.response.data);
          emit(
            state.copyWith(
              loginStatus: LoginStatus.failure,
              errorMessage: error.response.data['message'],
            ),
          );
        })
        .onError((error, stackTrace) {
          print(error);
          emit(
            state.copyWith(
              loginStatus: LoginStatus.failure,
              errorMessage: "Something went wrong!",
            ),
          );
        });
  }

  FutureOr<void> _onUpdateProfileEvent(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    // emit(state.copyWith(
    //     userInfoStatus : UserInfoStatus.loading
    // ));
    // await ApiService.postMethod(endPoint: 'user' , body: {
    //   "name": event.name
    // }).then((response) {
    //   print(response.data);
    //   userModel = AuthResponseModel(
    //       user: User.fromJson(response.data));
    //   saveToken(userModel!.token!);
    //   ApiService.init();
    //   emit(state.copyWith(
    //       userInfoStatus: UserInfoStatus.success
    //   ));
    // }).catchError((error) {
    //   print(error);
    //   emit(state.copyWith(
    //       userInfoStatus: UserInfoStatus.failure,
    //       errorMessage: error.response.data['message']
    //   ));
    // }).onError((error, stackTrace) {
    //   print(error);
    //   emit(state.copyWith(
    //       userInfoStatus: UserInfoStatus.failure,
    //       errorMessage: "Something went wrong!"
    //   ));
    // });
  }

  FutureOr<void> _onUpdatePasswordEvent(
    UpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(resetPasswordStatus: ResetPasswordStatus.loading));
    await ApiService.patchMethod(
          endPoint: 'Auth/ResetPassword',
          body: {
            'newPassword': event.password,
            'confirmPassword': event.password,
            'email': event.email,
          },
        )
        .then((response) {
          emit(
            state.copyWith(resetPasswordStatus: ResetPasswordStatus.success),
          );
        })
        .catchError((error) {
          emit(
            state.copyWith(
              resetPasswordStatus: ResetPasswordStatus.failure,
              errorMessage: error.response.data['message'],
            ),
          );
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(
              resetPasswordStatus: ResetPasswordStatus.failure,
              errorMessage: "حدث خطأ ما",
            ),
          );
        });
  }

  FutureOr<void> _onSendOtpEvent(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(sendOtpStatus: SendOtpStatus.loading));
    await ApiService.patchMethod(
          endPoint: 'Auth/SendOtp',
          body: {'email': event.email},
        )
        .then((response) {
          emit(state.copyWith(sendOtpStatus: SendOtpStatus.success));
        })
        .catchError((error) {
          emit(
            state.copyWith(
              sendOtpStatus: SendOtpStatus.failure,
              errorMessage: error.response.data['message'],
            ),
          );
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(
              sendOtpStatus: SendOtpStatus.failure,
              errorMessage: "حدث خطأ ما",
            ),
          );
        });
  }

  FutureOr<void> _onVerifyOtpEvent(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(verifyOtpStatus: VerifyOtpStatus.loading));
    await ApiService.patchMethod(
          endPoint: 'Auth/VerifyOtp',
          body: {'email': event.email, 'code': event.code},
        )
        .then((response) {
          emit(state.copyWith(verifyOtpStatus: VerifyOtpStatus.success));
        })
        .catchError((error) {
          emit(
            state.copyWith(
              verifyOtpStatus: VerifyOtpStatus.failure,
              errorMessage: error.response.data['message'],
            ),
          );
        })
        .onError((error, stackTrace) {
          emit(
            state.copyWith(
              verifyOtpStatus: VerifyOtpStatus.failure,
              errorMessage: "حدث خطأ ما",
            ),
          );
        });
  }
}
