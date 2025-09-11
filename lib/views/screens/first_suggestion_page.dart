import 'package:clothes_store/blocs/suggested_bloc/suggested_clothes_bloc.dart';
import 'package:clothes_store/views/screens/search_page.dart';
import 'package:clothes_store/views/screens/second_suggestion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constant/app_color.dart';
import '../../models/product_categories_response_model.dart';
import '../widgets/category_card.dart';
import '../widgets/custom_icon_button_widget.dart';
import '../widgets/dummy_search_widget_1.dart';
import '../widgets/loading_indicator/fashion_loader.dart';
import 'cart_page.dart';

class FirstSuggestionPage extends StatefulWidget {
  const FirstSuggestionPage({super.key});

  @override
  State<FirstSuggestionPage> createState() => _FirstSuggestionPageState();
}

class _FirstSuggestionPageState extends State<FirstSuggestionPage> {
  final ValueNotifier<int> currentSelected = ValueNotifier(0);

  List<String> events = ["Casual", "Evening Wear", "Sport", "Formal"];

  @override
  void initState() {
    BlocProvider.of<SuggestedClothesBloc>(
      context,
    ).add(GetClothesPerEventType(eventType: events[0]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 200,
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
                          'مرحبا بك في قسمنا المميز , مساعدك لتبدو أنيقا في جميع المناسبات',
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
                        'ماذا لديك اليوم؟',
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
                    return Container(
                      margin: EdgeInsets.only(top: 12),
                      height: 96,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: events.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 16);
                        },
                        itemBuilder: (context, index) {
                          return CategoryCard(
                            selected: value == index,
                            data: CategoriesResponseModel(name: events[index]),
                            onTap: () {
                              currentSelected.value = index;
                              BlocProvider.of<SuggestedClothesBloc>(
                                context,
                              ).add(
                                GetClothesPerEventType(
                                  eventType: events[index].replaceAll(' ', ''),
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
          ),
          ValueListenableBuilder(
            valueListenable: currentSelected,
            builder: (context, index, child) {
              return BlocBuilder<SuggestedClothesBloc, SuggestedClothesState>(
                builder: (context, state) {
                  String t = events[index].replaceAll(' ', '');
                  return state.productsPerEventTypeStatus[t] ==
                              GetProductStatus.loading ||
                          state.productsPerEventTypeStatus[t] ==
                              null
                      ? FashionLoader(color: Colors.white)
                      : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(12),
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // 3 columns
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount:
                              state
                                  .productsPerEventType[t]
                                  ?.length ??
                              0,
                          itemBuilder: (context, innerIndex) {
                            return InkWell(
                              onTap: () {
                                BlocProvider.of<SuggestedClothesBloc>(
                                  context,
                                ).add(
                                  GetSuggestedClothesEvent(
                                    productId:
                                        state
                                            .productsPerEventType[t]![innerIndex]
                                            .id!,
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SecondSuggestionPage(image: state
                                        .productsPerEventType[t]![innerIndex]
                                          .image! ,),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Image.network(
                                    state
                                        .productsPerEventType[t]![innerIndex]
                                        .image!,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),
                              ),
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
    );
  }
}
