import 'package:clothes_store/constant/app_color.dart';
import 'package:flutter/material.dart';

class TryAgainWidget extends StatelessWidget {
  const TryAgainWidget({super.key, this.onTap, required this.message});

  final void Function()? onTap;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 15,
      children: [
        Text(message, style: TextStyle(color: Colors.black, fontSize: 18)),
        onTap == null
            ? SizedBox.shrink()
            : InkWell(
              onTap: onTap,
              child: Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.primary,
                ),
                child: Center(
                  child: Text(
                    "إعادة المحاولة",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
