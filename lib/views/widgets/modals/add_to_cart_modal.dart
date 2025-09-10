import 'package:clothes_store/blocs/cart_bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/views/screens/cart_page.dart';

import '../../../utils/show_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddToCartModal extends StatefulWidget {
  final double price;
  final int productId;
  final bool isForShose;

  @override
  const AddToCartModal({super.key, required this.price, required this.productId, required this.isForShose});

  _AddToCartModalState createState() => _AddToCartModalState();
}

class _AddToCartModalState extends State<AddToCartModal> {
  final ValueNotifier<int> quantity = ValueNotifier(1);
  List<String> sizes = ["XS", "S", "M", "L", "XL", "XXL"];
  final List<String> colors = [
    "أسود",
    "أبيض",
    "أحمر",
    "أزرق",
    "أخضر",
    "أصفر",
    "فضي",
  ];

  String? selectedSize;
  String? selectedColor;


  @override
  void initState() {
    if(widget.isForShose){
      sizes = List.generate(7, (i)=> '${36 + i }');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ----------
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 6,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColor.primarySoft,
            ),
          ),
          // Section 1 - increment button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(right: 6),
                child: Text(
                  'الكمية: ',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0xFF0A0E2F).withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (quantity.value > 1) quantity.value--;
                    },
                    child: Icon(Icons.remove, size: 20, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.primary,
                      shape: CircleBorder(),
                      backgroundColor: AppColor.border,
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: quantity,
                    builder: (context, value, child) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$value',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (quantity.value < 20) {
                        quantity.value++;
                      } else {
                        showMessage(
                          "لايمكنك طلب أكثر من 20 عنصر من هذا المنتج",
                        );
                      }
                    },
                    child: Icon(Icons.add, size: 20, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.primary,
                      shape: CircleBorder(),
                      backgroundColor: AppColor.border,
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Text(
            "اختر قياس",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: sizes.map((size) {
              final isSelected = selectedSize == size;
              return ChoiceChip(
                label: Text(size),
                selectedColor: AppColor.primary,

                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    selectedSize = size;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "اختر لون",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: colors.map((color) {
              final isSelected = selectedColor == color;
              return ChoiceChip(
                label: Text(color),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              );
            }).toList(),
          ),
          // Section 2 - Total and add to cart button
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 18),
            padding: EdgeInsets.all(4),
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColor.primarySoft,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.only(right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'الإجمالي',
                          style: TextStyle(fontSize: 10, fontFamily: 'poppins'),
                        ),
                        ValueListenableBuilder(
                          valueListenable: quantity,
                          builder: (context, value, child) {
                            return Text(
                              ' ل.س ${value * widget.price}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ElevatedButton(
                    onPressed: () {
                      if(selectedSize == null){
                        showMessage("رجاء قم باختيار قياس");
                        return;
                      }
                      if(selectedColor == null){
                        showMessage("رجاء قم باختيار لون");
                        return;
                      }
                      BlocProvider.of<CartBloc>(context).add(
                        AddItemToCartEvent(
                          productId: widget.productId,
                          quantity: quantity.value,
                          size: selectedSize!,
                          color: selectedColor!,
                        ),
                      );
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'الحفظ للسلة',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
