import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/core/model/Search.dart';

class PopularSearchCard extends StatelessWidget {
  final String title;
  final int count;
  const PopularSearchCard({required this.title , required this.count, required this.onTap});

  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text('${title}'),
            ),
            Expanded(
              child: Text('${count}'),
            ),
          ],
        ),
      ),
    );
  }
}
