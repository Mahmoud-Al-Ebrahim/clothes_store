import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/core/model/Product.dart';
import 'package:clothes_store/core/services/ProductService.dart';
import 'package:clothes_store/views/widgets/item_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/products_bloc/products_bloc.dart';

class SearchResultPage extends StatefulWidget {
  final String searchKeyword;

  SearchResultPage({required this.searchKeyword});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  late final TabController tabController;
  TextEditingController searchInputController = TextEditingController();
  List<Product> searchedProductData = ProductService.searchedProductData;

  @override
  void initState() {
    BlocProvider.of<ProductsBloc>(
      context,
    ).add(SearchProductsEvent(text: widget.searchKeyword));
    super.initState();
    searchInputController.text = widget.searchKeyword;
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            'assets/icons/Arrow-left.svg',
            color: Colors.white,
          ),
        ),
        title: Container(
          height: 40,
          child: TextField(
            autofocus: false,
            onSubmitted: (text) {
              BlocProvider.of<ProductsBloc>(
                context,
              ).add(SearchProductsEvent(text: text));
              BlocProvider.of<ProductsBloc>(
                context,
              ).add(AddSearchHistoryEvent(text: text));
            },
            controller: searchInputController,
            style: TextStyle(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.3),
              ),
              hintText: 'ابحث عن منتجات...',
              prefixIcon: Container(
                padding: EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/icons/Search.svg',
                  color: Colors.white,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              fillColor: Colors.white.withOpacity(0.1),
              filled: true,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          return state.searchProductsStatus == SearchProductsStatus.loading
              ? FashionLoader()
              : state.searchResult.isEmpty ? Center(
            child: Text("لايوجد نتائج لعرضها"),
          ) : ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 16, top: 16),
                    child: Text(
                      'نتائج البحث ل ${widget.searchKeyword}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(
                        state.searchResult.length,
                        (index) =>
                            ItemCard(product: state.searchResult[index]),
                      ),
                    ),
                  ),
                ],
              );
        },
      ),
    );
  }
}
