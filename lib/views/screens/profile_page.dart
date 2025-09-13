import 'package:clothes_store/utils/my_shared_pref.dart';
import 'package:clothes_store/views/screens/favorites_page.dart';
import 'package:clothes_store/views/screens/last_seen_products_page.dart';
import 'package:clothes_store/views/screens/orders_page.dart';
import 'package:clothes_store/views/screens/update_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/views/widgets/main_app_bar_widget.dart';
import 'package:clothes_store/views/widgets/menu_tile_widget.dart';

import '../../main.dart';
import '../../utils/api_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {

    print('iiiii ${MySharedPref.getImage()}');

    return Scaffold(
      appBar: MainAppBar(cartValue: 2, chatValue: 2),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture - Username - Name
          InkWell(
            onTap: () async{
              await Navigator.push(context, MaterialPageRoute(builder: (_)=> UpdateProfilePage()));
              setState(() {

              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg') ,
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: MySharedPref.getImage() == null ?  AssetImage('assets/images/pp.jpg') : NetworkImage(MySharedPref.getImage()!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Fullname
                  Container(
                    margin: EdgeInsets.only(bottom: 4, top: 14),
                    child: Text(
                      MySharedPref.getFullName()!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Username
                  Text(
                    '@${MySharedPref.getUserName()!}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Section 2 - Account Menu
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Text(
                    'الحساب',
                    style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.5),
                      letterSpacing: 6 / 100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> FavoritesPage()));
                  },
                  margin: EdgeInsets.only(top: 10),
                  icon: SvgPicture.asset(
                    'assets/icons/Heart.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'المفضلة',
                  subtitle: 'احفظ ماتفضله في قائمة خاصة',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> LastSeenProductsPage()));
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/Show.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'آخر مارأيته',
                  subtitle: 'الوصول السريع لآخر المنتجات المزارة',
                ),
                MenuTileWidget(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> OrdersPage()));
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/Bag.svg',
                    color: AppColor.secondary.withOpacity(0.5),
                  ),
                  title: 'الطلبات',
                  subtitle: 'جميع طلباتك تجدها هنا',
                ),
              ],
            ),
          ),

          // Section 3 - Settings
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Text(
                    'الإعدادات',
                    style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.5),
                      letterSpacing: 6 / 100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                MenuTileWidget(
                  onTap: () {
showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("هل انت متأكد أنك تريد تسجيل الخروج؟"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                       await MySharedPref.clear();
                    ApiService.init();
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(builder: (_) => MyApp()),
                    );
                                  },
                                  child: Text("نعم")),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("لا"),
                              ),
                            ],
                          );
               
                  });},
                  icon: SvgPicture.asset(
                    'assets/icons/Log Out.svg',
                    color: Colors.red,
                  ),
                  iconBackground: Colors.red.shade100,
                  title: 'تسجيل الخروج',
                  titleColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
