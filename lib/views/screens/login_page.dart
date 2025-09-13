import 'package:clothes_store/utils/my_shared_pref.dart';
import 'package:clothes_store/views/screens/dashboard/products_page.dart';
import 'package:clothes_store/views/screens/otp_verification_page.dart';
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/views/screens/page_switcher.dart';
import 'package:clothes_store/views/screens/register_page.dart';

import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../utils/helper_functions.dart';
import '../../utils/show_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ValueNotifier<bool> showPassword = ValueNotifier(false);

  final pattern =
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';



  late final RegExp regex;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void initState() {
    regex = RegExp(pattern);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'تسجيل الدخول',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => RegisterPage()));
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColor.secondary.withOpacity(0.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ليس لديك حساب؟',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'إنشاء حساب',
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 24),
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Header
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 12),
            child: Text(
              'مرحباً بعودتك! 😁',
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
              'أحدث صيحات الموضة ودليل أناقتك في جميع المناسبات',
              style: TextStyle(
                color: AppColor.secondary.withOpacity(0.7),
                fontSize: 12,
                height: 150 / 100,
              ),
            ),
          ),
          // Section 2 - Form
          // Email
          TextField(
            autofocus: false,
            controller: email,
            decoration: InputDecoration(
              hintText: 'youremail@email.com',
              prefixIcon: Container(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/icons/Message.svg',
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
            ),
          ),
          SizedBox(height: 16),
          // Password
          ValueListenableBuilder(
            valueListenable: showPassword,
            builder: (context, value, child) {
              return TextField(
                autofocus: false,
                controller: password,
                obscureText: value,
                decoration: InputDecoration(
                  hintText: 'كلمة المرور',
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
          // Forgot Passowrd
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                if (email.text.isEmpty) {
                  showMessage("البريد الالكتروني لايجب أن يكون فارغاً");
                  return;
                }
                if (!regex.hasMatch(email.text)) {
                  showMessage("هذا البريد الالكتروني غير صالح");
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            OTPVerificationPage(cameFromRegisterPage: false , email : email.text),
                  ),
                );
              },
              child: Text(
                'نسيت كلمة المرور؟',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.secondary.withOpacity(0.5),
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary.withOpacity(0.1),
              ),
            ),
          ),
          // Sign In button
          BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (p,c)=> p.loginStatus != c.loginStatus,
            listener: (context, state) {
              if (state.loginStatus == LoginStatus.success) {
                bool isAdmin = BlocProvider.of<AuthBloc>(context).userModel?.user?.isAdmin ?? false;
                MySharedPref.saveIsAdmin(isAdmin);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) =>  isAdmin ? ProductsPage() : PageSwitcher()),
                  (route) => false,
                );
                showMessage('تم تسجيل الدخول بنجاح ✅', hasError: false);
              }
              if (state.loginStatus == LoginStatus.failure) {
                showMessage(state.errorMessage ?? "حدث خطأ ما");
              }
            },
            builder: (context, state) {
              return state.loginStatus == LoginStatus.loading
                  ? FashionLoader()
                  : ElevatedButton(
                    onPressed: onTapFunction,
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
                      'تسجيل الدخول',
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

  onTapFunction() async {
    if (email.text.isEmpty) {
      showMessage("البريد الالكتروني لايجب أن يكون فارغاً");
      return;
    }
    if (!regex.hasMatch(email.text)) {
      showMessage("هذا البريد الالكتروني غير صالح");
      return;
    }
    if (password.text.length < 8) {
      showMessage("كلمة المرور يجب أن تكون على الأقل 8 خانات");
      return;
    }
    if (await HelperFunctions.lostInternetConnection()) {
      showMessage("تحقق من اتصالك بالانترنت");
      return;
    }
    BlocProvider.of<AuthBloc>(
      context,
    ).add(LoginEvent(password: password.text, email: email.text));
    // showMessage('Login Successfully');
  }
}
