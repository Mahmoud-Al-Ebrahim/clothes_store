import 'package:clothes_store/models/products_response_model.dart';
import 'package:clothes_store/views/screens/dashboard/add_product_page.dart';
import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/core/model/Product.dart';
import 'package:clothes_store/views/screens/product_detail.dart';
import 'package:clothes_store/views/widgets/rating_tag.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../blocs/products_bloc/products_bloc.dart';
import '../../utils/my_shared_pref.dart';

class ItemCard extends StatefulWidget {
  final ProductsResponseModel product;
  final Color titleColor;
  final Color priceColor;
  final int? categoryId;
  final bool fromAdmin;
  final String? color;

  final String? info;

  ItemCard({
    required this.product,
    this.fromAdmin = false,
    this.categoryId,
    this.titleColor = Colors.black,
    this.priceColor = AppColor.primary,
    this.info, this.color,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetail(product: widget.product),
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 16 - 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // item image
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 16 - 8,
                  height: MediaQuery.of(context).size.width / 2 - 16 - 8,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child:
                      RatingTag(value: widget.product.rating?.toDouble() ?? 0),
                ),
                // Positioned(
                //     right: 10,
                //     top: 10,
                //     child: IconButton(
                //   icon: Icon(
                //     MySharedPref.isFavorite(widget.product.id.toString())
                //         ? Icons.favorite
                //         : Icons.favorite_border,
                //     color: Colors.red,
                //   ),
                //   onPressed: () async {
                //     await MySharedPref.toggleFavorite(widget.product);
                //     setState(() {});
                //     // Optionally: setState(() {}); if inside a StatefulWidget to update UI
                //   },
                // ))
              ],
            ),

            // item details
            Container(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name ?? widget.product.type ??  "لا اسم",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: widget.titleColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2, bottom: 8),
                    child: Row(
                      spacing: 5,
                      children: [
                        if(widget.product.orginalPrice != null)...{
                        Text(
                          '${widget.product.orginalPrice}ل.س ',
                          style: TextStyle(
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: widget.priceColor,
                          ),
                        ),
                    Text(
                      '${widget.product.discountedPrice}ل.س ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: widget.priceColor,
                      ),),
                        }else if(widget.product.price != widget.product.discountPercentage)...{
                          Text(
                            '${widget.product.price}ل.س ',
                            style: TextStyle(
                              fontSize: 10,
                              decoration: widget.product.discountPercentage ==null  ? null : TextDecoration.lineThrough,
                              fontWeight: FontWeight.w700,
                              decorationStyle: TextDecorationStyle.solid,
                              fontFamily: 'Poppins',
                              color: widget.priceColor,
                            ),
                          ),
                          if(widget.product.discountPercentage !=null)
                          Text(
                            '${widget.product.discountPercentage}ل.س ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: widget.priceColor,
                            ),),
                        }else ...{
                          Text(
                            '${widget.product.price}ل.س ',
                            style: TextStyle(
                              fontSize: 10,
                              decoration: TextDecoration.overline,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              color: widget.priceColor,
                            ),
                          ),
                        }
                      ],
                    ),
                  ),
                  if (widget.info != null)...{
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 8),
                      child: Text(
                        widget.info!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: widget.priceColor,
                        ),
                      ),
                    ),
                    Row(children: [
                      Text('اللون: '),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xff${widget.color?.substring(1)}')),
                          border: Border.all(color: Colors.black  ,width: 0.5),
                          shape: BoxShape.circle
                        ),
                      )
                    ],)
                  },
                  if (widget.product.categoryName != null)
                    Text(
                      widget.product.categoryName!,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  if (widget.fromAdmin)
                    Row(spacing: 10, children: [
                      InkWell(
                          onTap: () {
                            showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              // user must tap a button
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text(
                                    "حذف المنتج",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: const Text(
                                    "هل أنت متأكد أنك تريد حذف المنتج؟ لن يتم استعادة المنتج بعد حذفه",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("إلغاء",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<ProductsBloc>(context)
                                            .add(DeleteProductEvent(
                                          id: widget.product.id!,
                                          categoryId: widget.categoryId!,
                                        ));
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text("حذف",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AddEditProductPage(
                                        product: widget.product,
                                      )),
                            );
                          },
                          child: Icon(Icons.edit, color: AppColor.primary)),
                    ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
