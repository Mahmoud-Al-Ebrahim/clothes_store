import 'package:clothes_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:clothes_store/models/cart_response_model.dart';
import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartTile extends StatelessWidget {
  final GetCartResponseModel data;

  CartTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border, width: 1),
      ),
      child: Row(
        spacing: 10,
        children: [
          // Image
          Container(
            width: 70,
            height: 70,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColor.border,
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(data.productImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  data.productName ?? "لا اسم",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'poppins',
                    color: AppColor.secondary,
                  ),
                ),
                // Product Price - Increment Decrement Button
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Price
                      Expanded(
                        child: Text(
                          '${data.productPrice}ل.س ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                      // Increment Decrement Button
                      Container(
                        height: 26,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.primarySoft,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if(data.productQuantity! > 1) {
                                  BlocProvider.of<CartBloc>(context).add(
                                    UpdateItemInCartEvent(
                                      productId: data.productId!,
                                      quantity: data.productQuantity! - 1,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: 26,
                                height: 26,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.primarySoft,
                                ),
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${data.productQuantity}',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if(data.productQuantity! <= 20 ) {
                                  BlocProvider.of<CartBloc>(context).add(
                                    UpdateItemInCartEvent(
                                      productId: data.productId!,
                                      quantity: data.productQuantity! + 1,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: 26,
                                height: 26,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.primarySoft,
                                ),
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
