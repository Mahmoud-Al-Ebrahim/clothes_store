import 'package:clothes_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:clothes_store/utils/my_shared_pref.dart';
import 'package:clothes_store/utils/show_message.dart';
import 'package:clothes_store/views/screens/select_address_from_map_page.dart';
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/core/model/Cart.dart';
import 'package:clothes_store/core/services/CartService.dart';
import 'package:clothes_store/views/screens/order_success_page.dart';
import 'package:clothes_store/views/widgets/cart_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/try_again_widget.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartData = CartService.cartData;

  final ValueNotifier<String?> location = ValueNotifier(null);
  final TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'السلة',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            BlocBuilder<CartBloc, CartState>(
              buildWhen: (p, c) => p.getCartStatus != c.getCartStatus,
              builder: (context, state) {
                return state.getCartStatus == GetCartStatus.loading
                    ? FashionLoader()
                    : Text(
                      ' عناصر ${state.cartResponseModel?.length ?? 0}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    );
              },
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColor.primarySoft,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      // Checkout Button
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        buildWhen: (p, c) => p.getCartStatus != c.getCartStatus,
        builder: (context, state) {
          double total = 0;
          state.cartResponseModel?.forEach((item) {
            total += (item.productPrice! * item.productQuantity!);
          });
          return state.getCartStatus == GetCartStatus.loading
              ? FashionLoader()
              : Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColor.border, width: 1),
                  ),
                ),
                child: BlocConsumer<CartBloc, CartState>(
                  listenWhen: (p, c) => p.checkoutStatus != c.checkoutStatus,
                  listener: (context, state) {
                    if (state.checkoutStatus == CheckoutStatus.success) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => OrderSuccessPage(),
                        ),
                      );
                    }
                    if (state.checkoutStatus == CheckoutStatus.failure) {
                      showMessage(state.errorMessage);
                    }
                  },
                  builder: (context, state) {
                    return state.checkoutStatus == CheckoutStatus.loading
                        ? FashionLoader()
                        : ElevatedButton(
                          onPressed: () {
                            if (location.value != null) {
                              BlocProvider.of<CartBloc>(
                                context,
                              ).add(CheckOutEvent(location: location.value!));
                            } else {
                              showMessage("رجاء قم بإضافة عنوان للشحن");
                            }
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
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 6,
                                child: Text(
                                  'طلب المنتجات',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 26,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              Flexible(
                                flex: 6,
                                child: Text(
                                  ' ل.س${total}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                  },
                ),
              );
        },
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.getCartStatus == GetCartStatus.loading ||
              state.cartTransactionStatus == CartTransactionStatus.loading) {
            return Center(child: FashionLoader());
          }
          if (state.getCartStatus == GetCartStatus.failure) {
            return Center(
              child: TryAgainWidget(
                message: state.errorMessage,
                onTap: () {
                  BlocProvider.of<CartBloc>(context).add(GetCartEvent());
                },
              ),
            );
          }
          if ((state.cartResponseModel?.length ?? 0) == 0) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 164,
                    height: 164,
                    margin: EdgeInsets.only(bottom: 32),
                    child: SvgPicture.asset('assets/icons/Paper Bag.svg'),
                  ),
                  Text(
                    'السلة فارغة ☹️',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'poppins',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 48, top: 12),
                    child: Text(
                      'اذهب للصفحة الرئيسية وتصفح منتجاتنا المميزة وقم بإضافتهم للسلة',
                      style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: AppColor.border,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'ابدأ التسوق',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColor.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          double total = 0;
          state.cartResponseModel?.forEach((item) {
            total += (item.productPrice! * item.productQuantity!);
          });
          return ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CartTile(data: state.cartResponseModel![index]);
                },
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemCount: state.cartResponseModel?.length ?? 0,
              ),
              // Section 2 - Shipping Information
              Container(
                margin: EdgeInsets.only(top: 24),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 12,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.border, width: 1),
                ),
                child: Column(
                  children: [
                    // header
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'معلومات الشحن',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                              color: AppColor.secondary,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await showDialog<String>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('إضافة عنوان للشحن'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: address,
                                            decoration: InputDecoration(
                                              labelText: 'العنوان',
                                              hintText: 'قم بإدخال العنوان',
                                              errorText:
                                                  "العنوان لايجب أن يكون فارغاً",
                                            ),
                                            maxLines: 2,
                                          ),
                                          ElevatedButton.icon(
                                            icon: Icon(Icons.my_location),
                                            label: Text('اختيار موقع'),
                                            onPressed: () async {
                                              address.text =
                                                  (await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (_) =>
                                                              SelectAddressFromMapPage(),
                                                    ),
                                                  )) ??
                                                  '';
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pop(null); // Cancel returns null
                                          },
                                          child: Text('إلغاء'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (address.text.isNotEmpty) {
                                              location.value = address.text;
                                            }
                                            Navigator.of(context).pop(null);
                                          },
                                          child: Text('تأكيد'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/icons/Pencil.svg',
                              width: 16,
                              color: AppColor.secondary,
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColor.primary,
                              shape: CircleBorder(),
                              backgroundColor: AppColor.border,
                              elevation: 0,
                              padding: EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Name
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 12),
                            child: SvgPicture.asset(
                              'assets/icons/Profile.svg',
                              width: 18,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              MySharedPref.getFullName()!,
                              style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Address
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 12),
                            child: SvgPicture.asset(
                              'assets/icons/Home.svg',
                              width: 18,
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: location,
                            builder: (context, value, child) {
                              return Expanded(
                                child: Text(
                                  value ?? 'لم يتم اختيار عنوان',
                                  style: TextStyle(
                                    color: AppColor.secondary.withOpacity(0.7),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Phone Number
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 12),
                            child: SvgPicture.asset(
                              'assets/icons/Profile.svg',
                              width: 18,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              MySharedPref.getPhone()!,
                              style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Section 3 - Select Shipping method
              Container(
                margin: EdgeInsets.only(top: 24),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.border, width: 1),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColor.primarySoft,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      // Content
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'توصيل مجاني',
                            style: TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
     BlocBuilder<CartBloc, CartState>(
    buildWhen: (p, c) => p.getCartStatus != c.getCartStatus,
    builder: (context, state) {
    double total = 0;
    int q = 0;
    state.cartResponseModel?.forEach((item) {
    total += (item.productPrice! * item.productQuantity!);
    q += (item.productQuantity!);
    });
    return state.getCartStatus == GetCartStatus.loading
    ? FashionLoader()
        : Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        right: 16,
                        left: 16,
                        top: 16,
                        bottom: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'شحن خلال',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.secondary,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    '3-5 أيام',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColor.secondary.withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    '0 ل.س',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'الإجمالي',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.secondary,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    '${q} عناصر ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColor.secondary.withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    '$total ل.س ',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );})
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
