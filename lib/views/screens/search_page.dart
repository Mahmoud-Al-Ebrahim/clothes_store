import 'package:clothes_store/blocs/products_bloc/products_bloc.dart';
import 'package:clothes_store/views/widgets/loading_indicator/fashion_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/core/model/Search.dart';
import 'package:clothes_store/core/services/SearchService.dart';
import 'package:clothes_store/views/screens/search_result_page.dart';
import 'package:clothes_store/views/widgets/popular_search_card.dart';
import 'package:clothes_store/views/widgets/search_history_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchHistory> listSearchHistory = SearchService.listSearchHistory;
  List<PopularSearch> listPopularSearch = SearchService.listPopularSearch;


  @override
  void initState() {
    BlocProvider.of<ProductsBloc>(
      context,
    ).add(GetSearchHistoryEvent());
    super.initState();
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
        title: SizedBox(
          height: 40,
          child: TextField(
            autofocus: false,
            onSubmitted: (text) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchResultPage(searchKeyword: text),
                ),
              );
              BlocProvider.of<ProductsBloc>(
                context,
              ).add(AddSearchHistoryEvent(text: text));
            },
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
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Search History
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'سجل البحث...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  return state.searchHistoryTransaction ==
                          SearchHistoryTransaction.loading
                      ? FashionLoader()
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.searchHistory.length,
                        itemBuilder: (context, index) {
                          return SearchHistoryTile(
                            data: state.searchHistory[index],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => SearchResultPage(
                                        searchKeyword:
                                            state.searchHistory[index],
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      );
                },
              ),
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  return state.searchHistoryTransaction ==
                              SearchHistoryTransaction.loading ||
                          state.searchHistory.isEmpty
                      ? SizedBox.shrink()
                      : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<ProductsBloc>(
                              context,
                            ).add(ClearSearchHistoryEvent());
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColor.primary.withOpacity(0.3),
                            backgroundColor: AppColor.primarySoft,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Text(
                            'حذف سجل البحث',
                            style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.5),
                            ),
                          ),
                        ),
                      );
                },
              ),
            ],
          ),
          // Section 2 - Popular Search
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'عمليات بحث رائجة',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  return state.searchHistoryTransaction ==
                          SearchHistoryTransaction.loading
                      ? FashionLoader()
                      : Wrap(
                        direction: Axis.horizontal,
                        children: List.generate(
                          state.popularSearchHistory.length,
                          (index) {
                            return PopularSearchCard(
                              title: state.popularSearchHistory[index].term!,
                              count: state.popularSearchHistory[index].count!,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SearchResultPage(
                                          searchKeyword:
                                              state.searchHistory[index],
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
