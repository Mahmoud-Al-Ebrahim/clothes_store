import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constant/app_color.dart';
import '../../utils/my_shared_pref.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/item_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final favorites = MySharedPref.getFavoriteProducts();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text(
              'المفضلة',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColor.primarySoft,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(
              favorites.length,
              (index) => ItemCard(product: favorites[index]),
            ),
          ),
        ),
      ),
    );
  }
}
