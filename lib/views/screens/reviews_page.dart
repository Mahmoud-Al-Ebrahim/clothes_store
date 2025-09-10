import 'package:clothes_store/models/product_reviews_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:clothes_store/core/model/Review.dart';
import 'package:clothes_store/views/widgets/custom_app_bar.dart';
import 'package:clothes_store/views/widgets/review_tile.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ReviewsPage extends StatefulWidget {
  final List<ProductReviewsResponseModel> reviews;
  ReviewsPage({required this.reviews});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(
            title: 'آراء العملاء',
            leftIcon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
            rightIcon: SizedBox.shrink(),
            hideRight: true,
            leftOnTap: () {
              Navigator.of(context).pop();
            },
            rightOnTap: () {},
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            // Section 1 - Header
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          '${widget.reviews.length} مراجعة ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ReviewTile(review: widget.reviews[index]),
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemCount: widget.reviews.length,
            ),
          ],
        ),
      ),
    );
  }
}
