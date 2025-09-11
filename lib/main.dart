import 'package:clothes_store/blocs/suggested_bloc/suggested_clothes_bloc.dart';
import 'package:clothes_store/utils/api_service.dart';
import 'package:clothes_store/utils/my_shared_pref.dart';
import 'package:clothes_store/views/screens/dashboard/products_page.dart';
import 'package:clothes_store/views/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/app_bloc/store_bloc.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/cart_bloc/cart_bloc.dart';
import 'blocs/orders_bloc/orders_bloc.dart';
import 'blocs/products_bloc/products_bloc.dart';
import 'blocs/sensitive_connectivity/sensitive_connectivity_bloc.dart';
import 'core/services/localization/localization_service.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPref.init();
  await ApiService.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColor.primary,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SensitiveConnectivityBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => StoreBloc()),
        BlocProvider(create: (context) => OrdersBloc()),
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => SuggestedClothesBloc()),
      ],
      child: LocalizationService(
        child: Builder(
          builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              locale: context.locale,
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                fontFamily: 'Nunito',
              ),
              home: WelcomePage(),
            );
          }
        ),
      ),
    );
  }
}
