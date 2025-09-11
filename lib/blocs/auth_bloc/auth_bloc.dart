import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:clothes_store/utils/my_shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mime_type/mime_type.dart';
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
    ).then((response) {
      print(response.data);
      // userModel = AuthResponseModel.fromJson(response.data);
      // saveUser(
      //   userModel!.accessToken!,
      //   event.email,
      //   event.fullName,
      //   event.userName,
      //   event.phone,
      // );
      // ApiService.init();
      emit(
        state.copyWith(createAccountStatus: CreateAccountStatus.success),
      );
    }).catchError((error) {
      print(error.response);
      emit(
        state.copyWith(
          createAccountStatus: CreateAccountStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
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
    ).then((response) {
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
    }).catchError((error) {
      print(error);
      print(error.response.data);
      emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
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
    emit(state.copyWith(updateProfileStatus: UpdateProfileStatus.loading));

    Map<String , dynamic> data = {
      "fullName": event.fullName,
      "userName": event.userName,
      "email": event.email,
      "phoneNumber": event.phone,
    };
    data.removeWhere((k,v)=> v=='');
    if (event.image != null) {
      String fileName = event.image!.path.split('/').last;
      String mimeType = mime(fileName) ?? '';
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      await ApiService.postMethod(
          endPoint: 'Auth/UploadUserImage',
          form: FormData.fromMap({
            "file": await MultipartFile.fromFile(
              event.image!.path,
              filename: fileName,
              contentType: MediaType(mimee, type),
            ),
          })).then((response) async {
        String url = response.data['url'];
        await ApiService.postMethod(
            endPoint: 'Auth/UpdateImageUrl',
            body: {"imageUrl": url}).then((response) async {
          MySharedPref.setImage(url);
              if(data.isNotEmpty){
          await ApiService.putMethod(endPoint: 'Auth/Profile', body: data).then((response) async{
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          if(data.containsKey('email')) {
          sharedPreferences.setString('email', event.email);
          }
          if(data.containsKey('fullName')) {
          sharedPreferences.setString('fullName', event.fullName);
          }
          if(data.containsKey('userName')) {
          sharedPreferences.setString('userName', event.userName);
          }
          if(data.containsKey('phone')) {
          sharedPreferences.setString('phone', event.phone);
          }
          emit(
          state.copyWith(
          updateProfileStatus: UpdateProfileStatus.success,
          ),
          );
          }).catchError((error) {
          print(error);
          print(error.response.data);
          emit(
          state.copyWith(
          updateProfileStatus: UpdateProfileStatus.failure,
          errorMessage: error.response.toString(),
          ),
          );
          }).onError((error, stackTrace) {
          print(error);
          emit(
          state.copyWith(
          updateProfileStatus: UpdateProfileStatus.failure,
          errorMessage: "Something went wrong!",
          ),
          );
          });
          }else {
                emit(
                  state.copyWith(
                    updateProfileStatus: UpdateProfileStatus.success,
                  ),
                );
              }
        }).catchError((error) {
          print(error);
          print(error.response.data);
          emit(
            state.copyWith(
              updateProfileStatus: UpdateProfileStatus.failure,
              errorMessage: error.response.toString(),
            ),
          );
        }).onError((error, stackTrace) {
          print(error);
          emit(
            state.copyWith(
              updateProfileStatus: UpdateProfileStatus.failure,
              errorMessage: "Something went wrong!",
            ),
          );
        });
      }).catchError((error) {
        print(error);
        print(error.response.data);
        emit(
          state.copyWith(
            updateProfileStatus: UpdateProfileStatus.failure,
            errorMessage: error.response.toString(),
          ),
        );
      }).onError((error, stackTrace) {
        print(error);
        emit(
          state.copyWith(
            updateProfileStatus: UpdateProfileStatus.failure,
            errorMessage: "Something went wrong!",
          ),
        );
      });
    } else {

      await ApiService.putMethod(endPoint: 'Auth/Profile', body: data).then((response) async{
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        if(data.containsKey('email')) {
          sharedPreferences.setString('email', event.email);
        }
        if(data.containsKey('fullName')) {
          sharedPreferences.setString('fullName', event.fullName);
        }
        if(data.containsKey('userName')) {
          sharedPreferences.setString('userName', event.userName);
        }
        if(data.containsKey('phone')) {
          sharedPreferences.setString('phone', event.phone);
        }
        emit(
          state.copyWith(
            updateProfileStatus: UpdateProfileStatus.success,
          ),
        );
      }).catchError((error) {
        print(error);
        print(error.response.data);
        emit(
          state.copyWith(
            updateProfileStatus: UpdateProfileStatus.failure,
            errorMessage: error.response.toString(),
          ),
        );
      }).onError((error, stackTrace) {
        print(error);
        emit(
          state.copyWith(
            updateProfileStatus: UpdateProfileStatus.failure,
            errorMessage: "Something went wrong!",
          ),
        );
      });
    }
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
    //       errorMessage: error.response.toString()
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
    await ApiService.postMethod(
      endPoint: 'Auth/ResetPassword',
      body: {
        'newPassword': event.password,
        'confirmPassword': event.password,
        'email': event.email,
      },
    ).then((response) {
      emit(
        state.copyWith(resetPasswordStatus: ResetPasswordStatus.success),
      );
    }).catchError((error) {
      emit(
        state.copyWith(
          resetPasswordStatus: ResetPasswordStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
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
    await ApiService.postMethod(
      endPoint: 'Auth/SendOtp',
      body: {'email': event.email},
    ).then((response) {
      emit(state.copyWith(sendOtpStatus: SendOtpStatus.success));
    }).catchError((error) {
      print('error.response.toString()');
      print(error.response.toString());
      emit(
        state.copyWith(
          sendOtpStatus: SendOtpStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error.toString());
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
    await ApiService.postMethod(
      endPoint: 'Auth/VerifyOtp',
      body: {'email': event.email, 'code': event.code},
    ).then((response) {
      emit(state.copyWith(verifyOtpStatus: VerifyOtpStatus.success));
    }).catchError((error) {
      emit(
        state.copyWith(
          verifyOtpStatus: VerifyOtpStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      emit(
        state.copyWith(
          verifyOtpStatus: VerifyOtpStatus.failure,
          errorMessage: "حدث خطأ ما",
        ),
      );
    });
  }
}
