import 'package:clothes_store/models/products_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/suggested_bloc/suggested_clothes_bloc.dart';
import '../../constant/app_color.dart';
import '../widgets/item_card.dart';
import '../widgets/loading_indicator/fashion_loader.dart';

class SecondSuggestionPage extends StatefulWidget {
  const SecondSuggestionPage({super.key, required this.image});


  final String image;
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
          SizedBox(height: 15,),
          Container(
            width: MediaQuery.of(context).size.width / 2 - 16 - 8,
            height: MediaQuery.of(context).size.width / 2 - 16 - 8,
            padding: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 15,),

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
                              "القياس ${state.suggestedProducts![index].size}  \n الستايل ${state.suggestedProducts![index].style}",
                              product: ProductsResponseModel(
                                id: state.suggestedProducts![index].productId,
                                name: state.suggestedProducts![index].name ?? state.suggestedProducts![index].type,
                                price: state.suggestedProducts![index].price,
                                imageUrl:
                                state.suggestedProducts![index].image,
                              ),
                              color: state.suggestedProducts![index].color,
                            );})
                  );}
            ),
          ),
              ],
            ),
          );
  }
}
