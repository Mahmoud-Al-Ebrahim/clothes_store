import 'package:clothes_store/models/product_reviews_response_model.dart';
import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';

class ReviewTile extends StatelessWidget {
  final ProductReviewsResponseModel review;

  ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Photo
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade300,
            child: Center(
              child: Icon(
                Icons.supervised_user_circle_outlined,
                color: AppColor.primary,
              ),
            ),
          ),
          // Username - Rating - Comments
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username - Rating
                Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '${review.userName}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary,
                            fontFamily: 'poppins',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Comments
                Text(
                  review.text ?? '',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                    height: 150 / 100,
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
