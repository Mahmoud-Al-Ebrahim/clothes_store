import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/core/model/Search.dart';

class SearchHistoryTile extends StatelessWidget {
  const SearchHistoryTile({super.key, required this.data, required this.onTap});

  final SearchHistory data;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: AppColor.primarySoft,
              width: 1,
            ),
          ),
        ),
        child: Text('${data.title}'),
      ),
    );
  }
}
