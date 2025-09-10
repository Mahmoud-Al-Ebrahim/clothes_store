part of 'suggested_clothes_bloc.dart';




enum GetProductStatus { init, loading, failure, success }

enum GetSuggestedProducts { init, loading, failure, success }



class SuggestedClothesState {
  final Map<String , List<ProductsOfEventResponseModel>> productsPerEventType;
  final Map<String , GetProductStatus> productsPerEventTypeStatus;
  final List<SuggestedProductsResponseModel>? suggestedProducts;
  final GetSuggestedProducts getSuggestedProducts;
  final String errorMessage;

  SuggestedClothesState({
    this.productsPerEventType = const {},
    this.productsPerEventTypeStatus = const {},
    this.getSuggestedProducts = GetSuggestedProducts.loading,
    this.errorMessage = '',
    this.suggestedProducts = const []
  });

  SuggestedClothesState copyWith({
    final String? errorMessage,
    final Map<String , List<ProductsOfEventResponseModel>>? productsPerEventType,
    final Map<String , GetProductStatus>? productsPerEventTypeStatus,
    final List<SuggestedProductsResponseModel>? suggestedProducts,
    final GetSuggestedProducts? getSuggestedProducts,
  }) {
    return SuggestedClothesState(
      errorMessage: errorMessage ?? this.errorMessage,
      productsPerEventType: productsPerEventType ?? this.productsPerEventType,
      productsPerEventTypeStatus: productsPerEventTypeStatus ?? this.productsPerEventTypeStatus,
      getSuggestedProducts: getSuggestedProducts ?? this.getSuggestedProducts,
      suggestedProducts: suggestedProducts ?? this.suggestedProducts,
    );
  }
}
