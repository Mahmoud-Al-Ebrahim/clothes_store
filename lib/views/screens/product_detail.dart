import 'dart:math';

import 'package:clothes_store/blocs/products_bloc/products_bloc.dart';
import 'package:clothes_store/models/products_response_model.dart';
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/views/screens/image_viewer.dart';
import 'package:clothes_store/views/screens/reviews_page.dart';
import 'package:clothes_store/views/widgets/custom_app_bar.dart';
import 'package:clothes_store/views/widgets/modals/add_to_cart_modal.dart';
import 'package:clothes_store/views/widgets/rating_tag.dart';
import 'package:clothes_store/views/widgets/review_tile.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/my_shared_pref.dart';

class ProductDetail extends StatefulWidget {
  final ProductsResponseModel product;

  ProductDetail({required this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PageController productImageSlider = PageController();

  @override
  void initState() {
    BlocProvider.of<ProductsBloc>(context).add(GetProductReviewsEvent(productId: widget.product.id!));
    super.initState();
    MySharedPref.saveLastSeen(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    ProductsResponseModel product = widget.product;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColor.border, width: 1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return AddToCartModal(
                          price: product.discountPercentage ?? product.price!,
                          productId: product.id!,
                          isForShose: product.categoryName?.contains('Shose') ?? false,
                        );
                      },
                    );
                  },
                  child: Text(
                    'الإضافة للسلة',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - appbar & product image
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // product image
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ImageViewer(imageUrl: [product.imageUrl!]),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 310,
                  color: Colors.white,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    controller: productImageSlider,
                    children: List.generate(
                      1,
                      (index) =>
                          Image.network(product.imageUrl!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              // appbar
              CustomAppBar(
                title: '${product.categoryName}',
                leftIcon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
                rightIcon: Center(
                  child: Icon(
                      MySharedPref.isFavorite(widget.product.id.toString())
                      ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                      ),
                ),
                leftOnTap: () {
                  Navigator.of(context).pop();
                },
                rightOnTap: () async {
                  await MySharedPref.toggleFavorite(widget.product);
                  setState(() {});
                  // Optionally: setState(() {}); if inside a StatefulWidget to update UI
                }
              ),
              // indicator
              Positioned(
                bottom: 16,
                child: SmoothPageIndicator(
                  controller: productImageSlider,
                  count: 1,
                  effect: ExpandingDotsEffect(
                    dotColor: AppColor.primary.withOpacity(0.2),
                    activeDotColor: AppColor.primary.withOpacity(0.2),
                    dotHeight: 8,
                  ),
                ),
              ),
            ],
          ),
          // Section 2 - product info
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                            color: AppColor.secondary,
                          ),
                        ),
                      ),
                      RatingTag(
                        margin: EdgeInsets.only(right: 10),
                        value: product.rating?.toDouble() ?? 0,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 14),
                  child: Text(
                    '${product.price}ل.س ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'poppins',
                      color: AppColor.primary,
                    ),
                  ),
                ),
                Text(
                  '${product.description}',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                    height: 150 / 100,
                  ),
                ),
              ],
            ),
          ),

          // Section 5 - Reviews
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              return state.getProductReviewsStatus ==
                      GetProductReviewsStatus.loading
                  ? FashionLoader()
                  : Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          initiallyExpanded: true,
                          childrenPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 0,
                          ),
                          tilePadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0,
                          ),
                          title: Text(
                            'آراء العملاء',
                            style: TextStyle(
                              color: AppColor.secondary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'poppins',
                            ),
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (context, index) => ReviewTile(
                                    review: state.productReviewsResponseModel![index],
                                  ),
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 16),
                              itemCount: min(2 , state.productReviewsResponseModel?.length ?? 0),
                            ),
                            if((state.productReviewsResponseModel?.length?? 0 )  > 0)Container(
                              margin: EdgeInsets.only(
                                right: 52,
                                top: 12,
                                bottom: 6,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ReviewsPage(
                                            reviews: state.productReviewsResponseModel ?? [],
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: AppColor.primary,
                                  elevation: 0,
                                  backgroundColor: AppColor.primarySoft,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'مشاهدة جميع الآراء',
                                  style: TextStyle(
                                    color: AppColor.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
