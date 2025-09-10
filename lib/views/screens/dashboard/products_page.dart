import 'package:clothes_store/blocs/products_bloc/products_bloc.dart';
import 'package:clothes_store/views/screens/dashboard/add_product_page.dart';
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
            Map<String, dynamic>? data = await showAddDiscountDialog(context);
            if (data != null) {
              BlocProvider.of<ProductsBloc>(context).add(AddDiscountEvent(
                  discountPercentage: data['discountPercentage'],
                  startDate: data['startDate'],
                  endDate: data['endDate']));
            }
          },
          child: Icon(Icons.percent),
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

  Future<Map<String, dynamic>?> showAddDiscountDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final discountController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "إضافة خصم",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: discountController,
                      decoration: const InputDecoration(
                        labelText: "نسبة الخصم (%)",
                        hintText: "مثال: 15.5",
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "يرجى إدخال نسبة الخصم";
                        }
                        final value = double.tryParse(val);
                        if (value == null || value <= 0) {
                          return "النسبة يجب أن تكون رقم موجب";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(
                        startDate == null
                            ? "اختر تاريخ البداية"
                            : "تاريخ البداية: ${startDate!.toLocal()}"
                                .split(' ')[0],
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            startDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        endDate == null
                            ? "اختر تاريخ النهاية"
                            : "تاريخ النهاية: ${endDate!.toLocal()}"
                                .split(' ')[0],
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: startDate ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            endDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (startDate == null || endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("يرجى اختيار تاريخ البداية والنهاية")),
                    );
                    return;
                  }
                  if (endDate!.isBefore(startDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("تاريخ النهاية يجب أن يكون بعد البداية")),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    "discountPercent": double.parse(discountController.text),
                    "startDate": startDate,
                    "endDate": endDate,
                  });
                }
              },
              child: const Text("حفظ"),
            ),
          ],
        );
      },
    );
  }
}
