import 'package:clothes_store/blocs/products_bloc/products_bloc.dart';
import 'package:clothes_store/models/product_reviews_response_model.dart';
import 'package:clothes_store/utils/my_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:clothes_store/constant/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewTile extends StatelessWidget {
  final ProductReviewsResponseModel review;
  final int productId;

  ReviewTile({required this.review, required this.productId});

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
                if (MySharedPref.getUserName() == review.userName)
                  Row(
                    spacing: 10,
                    children: [
                      InkWell(
                          onTap: () {
                            BlocProvider.of<ProductsBloc>(context)
                                .add(DeleteReviewEvent(review.id!, productId));
                          },
                          child: Icon(Icons.delete , size: 15, color: Colors.red,)),
                      InkWell(
                          onTap: () {
                            showAddCommentDialog(context , (text) {
                              BlocProvider.of<ProductsBloc>(context).add(
                                  EditReviewToProductEvent(
                                      reviewId:    review.id!,
                                      productId: productId,
                                      comment: text
                                  ));
                            },comment: review.text);

                          },
                          child: Icon(Icons.edit, size: 15)),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showAddCommentDialog(
      BuildContext context, Function(String) onSubmit,
      {String? comment}) async {
    TextEditingController _commentController =
    TextEditingController(text: comment ?? '');

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تعديل تعليق'),
          content: TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'اكتب رأيك هنا...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final comment = _commentController.text.trim();
                if (comment.isNotEmpty) {
                  onSubmit(comment); // Call the callback
                  Navigator.of(context).pop(); // Close dialog
                } else {
                  // Optionally show an error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('التعليق لايجب أن يكون فارغاً')),
                  );
                }
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

}
