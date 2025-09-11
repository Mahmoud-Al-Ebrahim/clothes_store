import 'package:clothes_store/views/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/views/screens/page_switcher.dart';

import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../utils/helper_functions.dart';
import '../../utils/show_message.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/loading_indicator/fashion_loader.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key, required this.email});

  final String email;

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final ValueNotifier<bool> showPassword = ValueNotifier(false);
  final ValueNotifier<bool> showPassword2 = ValueNotifier(false);

  final TextEditingController password = TextEditingController();
  final TextEditingController confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'تحديث كلمة المرور',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 12),
            child: Text(
              'لنقم بتغيير كلمة المرور',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 32),
            child: Text(
              'قم باختيار كلمة مرور قوية , وتأكد من الحفاظ عليها وعدم نسيانها',
              style: TextStyle(
                color: AppColor.secondary.withOpacity(0.7),
                fontSize: 12,
                height: 150 / 100,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: showPassword,
            builder: (context, value, child) {
              return TextField(
                autofocus: false,
                obscureText: value,
                controller: password,
                decoration: InputDecoration(
                  hintText: 'كلمة المرور الجديدة',
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/Lock.svg',
                      color: AppColor.primary,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                  //
                  suffixIcon: IconButton(
                    onPressed: () {
                      showPassword.value = !value;
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/${!value ? 'Show' : 'Hide'}.svg',
                      color: AppColor.primary,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16),
          // Password
          ValueListenableBuilder(
            valueListenable: showPassword2,
            builder: (context, value, child) {
              return TextField(
                autofocus: false,
                obscureText: value,
                controller: confirm,
                decoration: InputDecoration(
                  hintText: "تأكيد كلمة المرور",
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/Lock.svg',
                      color: AppColor.primary,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                  //
                  suffixIcon: IconButton(
                    onPressed: () {
                      showPassword2.value = !value;
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/${!value ? 'Show' : 'Hide'}.svg',
                      color: AppColor.primary,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 15),
          BlocConsumer<AuthBloc, AuthState>(
            listenWhen:
                (p, c) => p.resetPasswordStatus != c.resetPasswordStatus,
            listener: (context, state) {
              if (state.resetPasswordStatus == ResetPasswordStatus.success) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => LoginPage()),
                  (route) => false,
                );
                showMessage('تم تحديث كلمة المرور بنجاح ✅', hasError: false);
              }
              if (state.resetPasswordStatus == ResetPasswordStatus.failure) {
                showMessage(state.errorMessage ?? "حدث خطأ ما");
              }
            },
            builder: (context, state) {
              return state.resetPasswordStatus == ResetPasswordStatus.loading
                  ? FashionLoader()
                  : ElevatedButton(
                    onPressed: () {
                      onTap();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 18,
                      ),
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'poppins',
                      ),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }

  onTap()async{
    if (password.text.length < 8 || confirm.text.length < 8) {
      showMessage("كلمة المرور يجب أن تكون على الأقل 8 خانات");
      return;
    }
    if (password.text != confirm.text) {
      showMessage("كلمات المرور غير متطابقة");
      return;
    }
    if (await HelperFunctions.lostInternetConnection()) {
    showMessage("تحقق من اتصالك بالانترنت");
    return;
    }
    BlocProvider.of<AuthBloc>(
    context,
    ).add(UpdatePasswordEvent(password: password.text, email: widget.email));
  }
}
