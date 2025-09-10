import 'package:clothes_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomIconButtonWidget extends StatelessWidget {
  final Widget icon;
  final EdgeInsetsGeometry? margin;
  final void Function() onTap;

  const CustomIconButtonWidget({
    required this.icon,
    required this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        margin: margin,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: icon,
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return state.getCartStatus != GetCartStatus.success ||
                    (state.cartResponseModel?.length ?? 0) == 0 ? SizedBox
                    .shrink() : Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColor.accent,
                  ),
                  child: Text(
                    '${state.cartResponseModel!.length}',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
