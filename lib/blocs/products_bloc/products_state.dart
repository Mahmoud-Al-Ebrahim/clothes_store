part of 'products_bloc.dart';

enum GetProductStatus { init, loading, failure, success }

enum GetProductCategoriesStatus { init, loading, failure, success }

enum GetFavoritesProductStatus { init, loading, failure, success }

enum GetProductDetailsStatus { init, loading, failure, success }

enum GetProductReviewsStatus { init, loading, failure, success }

enum AddProductReviewStatus { init, loading, failure, success }

enum FavoriteTransactionStatus { init, loading, failure, success }

enum SearchProductsStatus { init, loading, failure, success }

enum SearchHistoryTransaction { init, loading, failure, success }

enum GetFlashSaleStatus { init, loading, failure, success }

enum AdminTransactionStatus { init, loading, failure, success }

class ProductsState {
  final List<ProductsResponseModel>? productsResponseModel;
  final List<CategoriesResponseModel>? productCategoriesResponseModel;
  final FavoritesResponseModel? favoritesResponseModel;
  final List<ProductReviewsResponseModel>? productReviewsResponseModel;

  final SearchProductsStatus searchProductsStatus;
  final SearchHistoryTransaction searchHistoryTransaction;
  final GetProductStatus getProductStatus;
  final GetProductCategoriesStatus getProductCategoriesStatus;
  final GetFavoritesProductStatus getFavoritesProductStatus;
  final GetProductReviewsStatus getProductReviewsStatus;
  final AddProductReviewStatus addProductReviewStatus;
  final GetProductDetailsStatus getProductDetailsStatus;
  final Map<int , FavoriteTransactionStatus> favoriteTransactionStatus;
  final GetFlashSaleStatus getFlashSaleStatus;
  final AdminTransactionStatus adminTransactionStatus;

  final String errorMessage;

  final ProductsResponseModel? productDetails;

  final List<String> searchHistory;
  final List<PopularSearchResponseModel> popularSearchHistory;
  final List<ProductsResponseModel> searchResult;
  final List<ProductsResponseModel> flashSale;

  ProductsState({
    this.getProductReviewsStatus = GetProductReviewsStatus.loading,
    this.getProductCategoriesStatus = GetProductCategoriesStatus.loading,
    this.getProductStatus = GetProductStatus.loading,
    this.addProductReviewStatus = AddProductReviewStatus.init,
    this.getFavoritesProductStatus = GetFavoritesProductStatus.loading,
    this.getProductDetailsStatus = GetProductDetailsStatus.loading,
    this.searchProductsStatus = SearchProductsStatus.loading,
    this.searchHistoryTransaction = SearchHistoryTransaction.loading,
    this.getFlashSaleStatus = GetFlashSaleStatus.loading,
    this.adminTransactionStatus = AdminTransactionStatus.loading,
    this.favoriteTransactionStatus = const {},
    this.productReviewsResponseModel,
    this.favoritesResponseModel,
    this.searchHistory = const [],
    this.popularSearchHistory = const [],
    this.searchResult = const [],
    this.flashSale = const [],
    this.productCategoriesResponseModel,
    this.productsResponseModel,
    this.productDetails,
    this.errorMessage = '',
  });

  ProductsState copyWith({
    final List<ProductsResponseModel>? productsResponseModel,
    final List<CategoriesResponseModel>? productCategoriesResponseModel,
    final FavoritesResponseModel? favoritesResponseModel,
    final List<ProductReviewsResponseModel>? productReviewsResponseModel,
    final GetProductStatus? getProductStatus,
    final GetProductDetailsStatus? getProductDetailsStatus,
    final GetProductCategoriesStatus? getProductCategoriesStatus,
    final GetFavoritesProductStatus? getFavoritesProductStatus,
    final GetProductReviewsStatus? getProductReviewsStatus,
    final AdminTransactionStatus? adminTransactionStatus,
    final AddProductReviewStatus? addProductReviewStatus,
    final SearchProductsStatus? searchProductsStatus,
    final SearchHistoryTransaction? searchHistoryTransaction,
    final ProductsResponseModel? productDetails,
    final GetFlashSaleStatus? getFlashSaleStatus,
    final Map<int , FavoriteTransactionStatus>? favoriteTransactionStatus,
    final List<String>? searchHistory,
    final List<PopularSearchResponseModel>? popularSearchHistory,
    final List<ProductsResponseModel>? searchResult,
    final List<ProductsResponseModel>? flashSale,
    final String? errorMessage,
  }) {
    return ProductsState(
      errorMessage: errorMessage ?? this.errorMessage,
      searchHistory: searchHistory ?? this.searchHistory,
      searchResult: searchResult ?? this.searchResult,
      getFlashSaleStatus: getFlashSaleStatus ?? this.getFlashSaleStatus,
      popularSearchHistory: popularSearchHistory ?? this.popularSearchHistory,
      searchProductsStatus: searchProductsStatus ?? this.searchProductsStatus,
      searchHistoryTransaction: searchHistoryTransaction ?? this.searchHistoryTransaction,
      getProductDetailsStatus: getProductDetailsStatus ?? this.getProductDetailsStatus,
      adminTransactionStatus: adminTransactionStatus ?? this.adminTransactionStatus,
      productDetails: productDetails ?? this.productDetails,
      addProductReviewStatus:
          addProductReviewStatus ?? this.addProductReviewStatus,
      productsResponseModel:
          productsResponseModel ?? this.productsResponseModel,
      productCategoriesResponseModel:
          productCategoriesResponseModel ?? this.productCategoriesResponseModel,
      favoritesResponseModel:
          favoritesResponseModel ?? this.favoritesResponseModel,
      productReviewsResponseModel:
          productReviewsResponseModel ?? this.productReviewsResponseModel,
      getProductStatus: getProductStatus ?? this.getProductStatus,
      getProductCategoriesStatus:
          getProductCategoriesStatus ?? this.getProductCategoriesStatus,
      getFavoritesProductStatus:
          getFavoritesProductStatus ?? this.getFavoritesProductStatus,
      getProductReviewsStatus:
          getProductReviewsStatus ?? this.getProductReviewsStatus,
      favoriteTransactionStatus:
          favoriteTransactionStatus ?? this.favoriteTransactionStatus,
    );
  }
}
