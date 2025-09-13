import 'package:clothes_store/blocs/products_bloc/products_bloc.dart';
import 'package:clothes_store/views/screens/dashboard/add_product_page.dart';
import 'package:clothes_store/views/screens/dashboard/discount_page.dart';
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/core/model/Category.dart';
import 'package:clothes_store/core/model/Product.dart';
import 'package:clothes_store/core/services/CategoryService.dart';
import 'package:clothes_store/core/services/ProductService.dart';
import 'package:clothes_store/views/screens/search_page.dart';
import 'package:clothes_store/views/widgets/category_card.dart';
import 'package:clothes_store/views/widgets/dummy_search_widget_1.dart';
import 'package:clothes_store/views/widgets/item_card.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main.dart';
import '../../../utils/api_service.dart';
import '../../../utils/my_shared_pref.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Category> categoryData = CategoryService.categoryData;
  List<Product> productData = ProductService.productData;

  final ValueNotifier<int> currentSelected = ValueNotifier(1);

  @override
  void initState() {
    BlocProvider.of<ProductsBloc>(context).add(GetProductCategoriesEvent());
    BlocProvider.of<ProductsBloc>(context).add(GetAllDiscountsEvent());
    BlocProvider.of<ProductsBloc>(
      context,
    ).add(GetProductsByCategoryEvent(categoryId: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Column(mainAxisSize: MainAxisSize.min, spacing: 10, children: [
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditProductPage()),
            );
          },
          child: Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DiscountPage()),
            );
          },
          child: Icon(Icons.percent),
        ),
            FloatingActionButton(
          onPressed: () async {
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

                });
          },
          child: SvgPicture.asset(
            'assets/icons/Log Out.svg',
            color: Colors.red,
          ),
        )
      ]),
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
                          'لوحة التحكم',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            height: 150 / 100,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
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
                            ? FashionLoader(
                                color: Colors.white,
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 12),
                                height: 96,
                                child: ListView.separated(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: state
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
                                      selected: value ==
                                          state
                                              .productCategoriesResponseModel![
                                                  index]
                                              .id,
                                      data:
                                          state.productCategoriesResponseModel![
                                              index],
                                      onTap: () {
                                        currentSelected.value = state
                                            .productCategoriesResponseModel![
                                                index]
                                            .id!;
                                        BlocProvider.of<ProductsBloc>(
                                          context,
                                        ).add(
                                          GetProductsByCategoryEvent(
                                            categoryId: state
                                                .productCategoriesResponseModel![
                                                    index]
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

          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              return state.getProductStatus == GetProductStatus.loading ||
                      state.adminTransactionStatus ==
                          AdminTransactionStatus.loading
                  ? FashionLoader()
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: List.generate(
                          state.productsResponseModel?.length ?? 0,
                          (index) => ItemCard(
                            product: state.productsResponseModel![index],
                            categoryId: currentSelected.value,
                            fromAdmin: true,
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
