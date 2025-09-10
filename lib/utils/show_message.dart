
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../constant/app_color.dart';
showMessage(
  String message, {
  bool hasError = true,
  bool showInRelease = true,
  Color? backGroundColor,
  Color? foreGroundColor,
  Toast timeShowing = Toast.LENGTH_LONG,
}) {
    Fluttertoast.cancel().then((value) => Fluttertoast.showToast(
          msg: message.tr(),
          backgroundColor: AppColor.primary,
          textColor:const Color(0xFFffffff),  //foreGroundColor ?? (hasError ? Colors.red : Colors.green),
          fontSize: 16,
          toastLength: timeShowing,
          gravity: ToastGravity.BOTTOM,
        ));
}

