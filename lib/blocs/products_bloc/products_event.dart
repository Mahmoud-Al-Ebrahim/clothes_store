part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class GetProductsByCategoryEvent extends ProductsEvent {
  final int categoryId;

  GetProductsByCategoryEvent({
    required this.categoryId,
  });
}

class GetFlashSaleEvent extends ProductsEvent {}

class GetProductCategoriesEvent extends ProductsEvent {}

class GetFavoriteProductsEvent extends ProductsEvent {}

class AddToFavoritesEvent extends ProductsEvent {
  final int productId;
  final String color;
  final String size;
  final int quantity;

  AddToFavoritesEvent(
      {required this.productId,
      required this.quantity,
      required this.size,
      required this.color});
}

class GetProductByIdEvent extends ProductsEvent {
  final int productId;

  GetProductByIdEvent({
    required this.productId,
  });
}

class RemoveFromFavoritesEvent extends ProductsEvent {
  final int productId;

  RemoveFromFavoritesEvent({
    required this.productId,
  });
}

class GetProductReviewsEvent extends ProductsEvent {
  final int productId;

  GetProductReviewsEvent({
    required this.productId,
  });
}

class AddReviewToProductEvent extends ProductsEvent {
  final int productId;
  final String comment;

  AddReviewToProductEvent({
    required this.productId,
    required this.comment,
  });
}

class AddSearchHistoryEvent extends ProductsEvent {
  final String text;

  AddSearchHistoryEvent({
    required this.text,
  });
}

class SearchProductsEvent extends ProductsEvent {
  final String text;

  SearchProductsEvent({
    required this.text,
  });
}

class GetSearchHistoryEvent extends ProductsEvent {
  GetSearchHistoryEvent();
}

class ClearSearchHistoryEvent extends ProductsEvent {
  ClearSearchHistoryEvent();
}

class GetPopularSearchHistoryEvent extends ProductsEvent {
  GetPopularSearchHistoryEvent();
}

class AddDiscountEvent extends ProductsEvent {
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;

  AddDiscountEvent({
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
  });
}

class DeleteProductEvent extends ProductsEvent {
  DeleteProductEvent( {required this.id , required this.categoryId,});

  final int id;
  final int categoryId;
}

class AddProductEvent extends ProductsEvent {
  final String name;
  final String description;
  final String gender;
  final String season;
  final String type;
  final String styleCloth;
  final double price;
  final int categoryId;
  final int quantity;
  final File image;

  AddProductEvent({
    required this.image,
    required this.description,
    required this.name,
    required this.gender,
    required this.season,
    required this.type,
    required this.price,
    required this.categoryId,
    required this.quantity,
    required this.styleCloth,
  });
}

class EditProductEvent extends ProductsEvent {
  final int id;
  final String name;
  final String description;
  final String gender;
  final String season;
  final String type;
  final String styleCloth;
  final double price;
  final int categoryId;
  final int quantity;
  final File? image;
  final String imageUrl;

  EditProductEvent({
    required this.imageUrl,
    this.image,
    required this.id,
    required this.description,
    required this.name,
    required this.gender,
    required this.season,
    required this.type,
    required this.price,
    required this.categoryId,
    required this.quantity,
    required this.styleCloth,
  });
}
