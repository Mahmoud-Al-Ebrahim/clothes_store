import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'sensitive_connectivity_bloc.dart';

class ConnectivityObserver {
  static ConnectivityObserver? instance;
  static createInstance(BuildContext context) {
    instance ??= ConnectivityObserver();
    Connectivity().onConnectivityChanged.listen((event) {
      BlocProvider.of<SensitiveConnectivityBloc>(context).add(
        ChangeConnectivityEvent(connectivityResult: event),
      );
    });
  }
}
