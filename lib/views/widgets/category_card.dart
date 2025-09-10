import 'package:clothes_store/models/product_categories_response_model.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final CategoriesResponseModel data;
  final Function() onTap;
  final bool selected;

  const CategoryCard({
    required this.data,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          color: selected ? Colors.white.withOpacity(0.10) : Colors.transparent,
        ),
        child: Column(
          children: [
            Flexible(
              child: Text(
                '${data.name}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
