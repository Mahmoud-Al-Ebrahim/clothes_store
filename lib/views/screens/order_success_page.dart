import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/views/screens/page_switcher.dart';

import 'orders_page.dart';

class OrderSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 184,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> OrdersPage()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColor.primary,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: AppColor.border,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'سجل الطلبات',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => PageSwitcher()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'متابعة التسوق',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 124,
              height: 124,
              margin: EdgeInsets.only(bottom: 32),
              child: SvgPicture.asset('assets/icons/Success.svg'),
            ),
            Text(
              'تمت إضافة الطلب بنجاح 😆',
              style: TextStyle(
                color: AppColor.secondary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                'لقد استلمنا طلبك ',
                style: TextStyle(color: AppColor.secondary.withOpacity(0.8)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
