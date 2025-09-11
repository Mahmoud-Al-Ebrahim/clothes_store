import 'dart:async';
import 'package:clothes_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:clothes_store/blocs/products_bloc/products_bloc.dart';
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_store/views/screens/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/core/model/Category.dart';
import 'package:clothes_store/core/model/Product.dart';
import 'package:clothes_store/core/services/CategoryService.dart';
import 'package:clothes_store/core/services/ProductService.dart';
import 'package:clothes_store/views/screens/search_page.dart';
import 'package:clothes_store/views/widgets/category_card.dart';
import 'package:clothes_store/views/widgets/custom_icon_button_widget.dart';
import 'package:clothes_store/views/widgets/dummy_search_widget_1.dart';
import 'package:clothes_store/views/widgets/flashsale_countdown_tile.dart';
import 'package:clothes_store/views/widgets/item_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categoryData = CategoryService.categoryData;
  List<Product> productData = ProductService.productData;

  final ValueNotifier<int> currentSelected = ValueNotifier(1);

  Timer? flashsaleCountdownTimer;
  Duration flashsaleCountdownDuration = Duration(
    hours: 24 - DateTime.now().hour,
    minutes: 60 - DateTime.now().minute,
    seconds: 60 - DateTime.now().second,
  );

  @override
  void initState() {
    BlocProvider.of<ProductsBloc>(context).add(GetProductCategoriesEvent());
    BlocProvider.of<ProductsBloc>(context).add(GetFlashSaleEvent());
    BlocProvider.of<ProductsBloc>(
      context,
    ).add(GetProductsByCategoryEvent(categoryId: 1));
    BlocProvider.of<CartBloc>(context).add(GetCartEvent());
    super.initState();
    startTimer();
  }

  void startTimer() {
    flashsaleCountdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setCountdown();
    });
  }

  void setCountdown() {
    if (mounted) {
      setState(() {
        final seconds = flashsaleCountdownDuration.inSeconds - 1;

        if (seconds < 1) {
          flashsaleCountdownTimer?.cancel();
        } else {
          flashsaleCountdownDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  void dispose() {
    if (flashsaleCountdownTimer != null) {
      flashsaleCountdownTimer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String seconds = flashsaleCountdownDuration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String minutes = flashsaleCountdownDuration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String hours = flashsaleCountdownDuration.inHours
        .remainder(24)
        .toString()
        .padLeft(2, '0');

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1
          Container(
            height: 190,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 26),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          'جِد أفضل صيحات الموضة المناسبة لك',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            height: 150 / 100,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          CustomIconButtonWidget(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CartPage(),
                                ),
                              );
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/Bag.svg',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                DummySearchWidget1(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Section 2 - category
          Container(
            width: MediaQuery.of(context).size.width,
            color: AppColor.secondary,
            padding: EdgeInsets.only(top: 12, bottom: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'فئات الألبسة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Category list
                ValueListenableBuilder(
                  valueListenable: currentSelected,
                  builder: (context, value, child) {
                    return BlocBuilder<ProductsBloc, ProductsState>(
                      builder: (context, state) {
                        return state.getProductCategoriesStatus ==
                                GetProductCategoriesStatus.loading
                            ? FashionLoader(color: Colors.white,)
                            : Container(
                              margin: EdgeInsets.only(top: 12),
                              height: 96,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                itemCount:
                                    state
                                        .productCategoriesResponseModel
                                        ?.length ??
                                    0,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 16);
                                },
                                itemBuilder: (context, index) {
                                  return CategoryCard(
                                    selected:
                                        value ==
                                        state
                                            .productCategoriesResponseModel![index]
                                            .id,
                                    data:
                                        state
                                            .productCategoriesResponseModel![index],
                                    onTap: () {
                                      currentSelected.value =
                                          state
                                              .productCategoriesResponseModel![index]
                                              .id!;
                                      BlocProvider.of<ProductsBloc>(
                                        context,
                                      ).add(
                                        GetProductsByCategoryEvent(
                                          categoryId:
                                              state
                                                  .productCategoriesResponseModel![index]
                                                  .id!,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Section 4 - Flash Sale
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تنزيلات لفترة محدودة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: FlashsaleCountdownTile(digit: hours[0]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: FlashsaleCountdownTile(digit: hours[1]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: FlashsaleCountdownTile(digit: minutes[0]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: FlashsaleCountdownTile(digit: minutes[1]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: Text(
                                ':',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: FlashsaleCountdownTile(digit: seconds[0]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: FlashsaleCountdownTile(digit: seconds[1]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, state) {
                    print(state.flashSale.length);
                    return state.getFlashSaleStatus ==
                            GetFlashSaleStatus.loading
                        ? FashionLoader()
                        : SizedBox(
                      height: 300,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.flashSale.length,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                              itemBuilder: (context , index) => Padding(
                                padding: const EdgeInsets.only(
                                  right: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    ItemCard(
                                      product: state.flashSale[index],
                                      titleColor: AppColor.primarySoft,
                                      priceColor: AppColor.accent,
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  10,
                                                ),
                                                child:
                                                LinearProgressIndicator(
                                                  minHeight: 10,
                                                  value: 0.4,
                                                  color:
                                                  AppColor.accent,
                                                  backgroundColor:
                                                  AppColor.border,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.local_fire_department,
                                            color: AppColor.accent,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: Container(
                                    //         color: Colors.amber,
                                    //         height: 10,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Section 5 - product list
          Padding(
            padding: EdgeInsets.only(right: 16, top: 16),
            child: Text(
              'توصيات اليوم...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              return state.getProductStatus == GetProductStatus.loading
                  ? FashionLoader()
                  : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(
                        state.productsResponseModel?.length ?? 0,
                        (index) => ItemCard(
                          product: state.productsResponseModel![index],
                        ),
                      ),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
