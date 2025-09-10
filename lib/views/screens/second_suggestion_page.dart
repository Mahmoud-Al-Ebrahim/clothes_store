import 'package:clothes_store/models/products_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/suggested_bloc/suggested_clothes_bloc.dart';
import '../../constant/app_color.dart';
import '../widgets/item_card.dart';
import '../widgets/loading_indicator/fashion_loader.dart';

class SecondSuggestionPage extends StatefulWidget {
  const SecondSuggestionPage({super.key});

  @override
  State<SecondSuggestionPage> createState() => _SecondSuggestionPageState();
}

class _SecondSuggestionPageState extends State<SecondSuggestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 90,
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
                      Text(
                        'مقترحاتنا المميزة الملائمة لالتزاماتك',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          height: 150 / 100,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),]
                        )
                ),
          Expanded(
            child: BlocBuilder<SuggestedClothesBloc, SuggestedClothesState>(
                builder: (context, state) {
                  return state.getSuggestedProducts ==
                      GetSuggestedProducts.loading
                      ? FashionLoader()
                      : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1/2.3
                          ),
                          itemCount:
                          state
                              .suggestedProducts
                              ?.length ??
                              0,
                          itemBuilder: (context, index) {
                            return  ItemCard(
                              info:
                              "القياس ${state.suggestedProducts![index].size} \n اللون ${state.suggestedProducts![index].color} \n الستايل ${state.suggestedProducts![index].style}",
                              product: ProductsResponseModel(
                                id: state.suggestedProducts![index].id,
                                name: state.suggestedProducts![index].name,
                                price: state.suggestedProducts![index].price,
                                imageUrl:
                                state.suggestedProducts![index].image,
                              ),
                            );})
                  );}
            ),
          ),
              ],
            ),
          );
  }
}
