import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:clothes_store/models/discounts_response_modell.dart';
import 'package:http_parser/http_parser.dart';

import 'package:clothes_store/models/popular_search_response_model.dart';
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:clothes_store/models/favorites_response_model.dart';
import 'package:clothes_store/models/product_categories_response_model.dart';
import 'package:clothes_store/models/product_reviews_response_model.dart';
import 'package:clothes_store/models/products_response_model.dart';
import 'package:mime_type/mime_type.dart';
import '../../models/product_details_model.dart';
import '../../utils/api_service.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsState()) {
    on<ProductsEvent>((event, emit) {});

    on<GetProductsByCategoryEvent>(_onGetProductsByCategoryEvent);
    on<GetFavoriteProductsEvent>(_onGetFavoriteProductsEvent);
    on<GetProductCategoriesEvent>(_onGetProductCategoriesEvent);
    on<GetProductReviewsEvent>(_onGetProductReviewsEvent);
    on<AddReviewToProductEvent>(_onAddReviewToProductEvent);
    on<AddToFavoritesEvent>(_onAddToFavoritesEvent);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavoritesEvent);
    on<GetProductByIdEvent>(_onGetProductByIdEvent);

    on<AddSearchHistoryEvent>(_onAddSearchHistoryEvent);
    on<FilteringEvent>(_onFilteringEvent);
    on<SearchProductsEvent>(_onSearchProductsEvent);
    on<ClearSearchHistoryEvent>(_onClearSearchHistoryEvent);
    on<GetSearchHistoryEvent>(_onGetSearchHistoryEvent);
    on<GetPopularSearchHistoryEvent>(_onGetPopularSearchHistoryEvent);
    on<GetFlashSaleEvent>(_onGetFlashSaleEvent);

    on<DeleteProductEvent>(_onDeleteProductEvent);
    on<AddDiscountEvent>(_onAddDiscountEvent);
    on<AddProductEvent>(_onAddProductEvent);
    on<EditProductEvent>(_onEditProductEvent);

    on<DeleteReviewEvent>(_onDeleteReviewEvent);
    on<EditReviewToProductEvent>(_onEditReviewToProductEvent);


    on<GetAllDiscountsEvent>(_onGetAllDiscountsEvent);
    on<DeleteDiscountEvent>(_onDeleteDiscountEvent);
  }

  FutureOr<void> _onGetProductsByCategoryEvent(
    GetProductsByCategoryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(getProductStatus: GetProductStatus.loading));
    await ApiService.getMethod(
      endPoint: 'Product/GetProductByCatgeory/${event.categoryId}',
    ).then((response) {
      log(response.data.toString());
      print(response.data.runtimeType);
      emit(
        state.copyWith(
          getProductStatus: GetProductStatus.success,
          productsResponseModel: productsResponseModelFromJson(
            response.data,
          ),
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getProductStatus: GetProductStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          getProductStatus: GetProductStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetFavoriteProductsEvent(
    GetFavoriteProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      state.copyWith(
        getFavoritesProductStatus: GetFavoritesProductStatus.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'favorites').then((response) {
      log('Favorite Sucesssssssssssssss');
      log(response.data.toString());
      emit(
        state.copyWith(
          getFavoritesProductStatus: GetFavoritesProductStatus.success,
          favoritesResponseModel: FavoritesResponseModel.fromJson(
            response.data,
          ),
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getFavoritesProductStatus: GetFavoritesProductStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      log('Favorite failedddddddddddd');
      emit(
        state.copyWith(
          getFavoritesProductStatus: GetFavoritesProductStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetProductCategoriesEvent(
    GetProductCategoriesEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      state.copyWith(
        getProductCategoriesStatus: GetProductCategoriesStatus.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Product/GetAllCategory')
        .then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          getProductCategoriesStatus: GetProductCategoriesStatus.success,
          productCategoriesResponseModel: categoriesResponseModelFromJson(
            response.data,
          ),
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getProductCategoriesStatus: GetProductCategoriesStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          getProductCategoriesStatus: GetProductCategoriesStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetProductReviewsEvent(
    GetProductReviewsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      state.copyWith(getProductReviewsStatus: GetProductReviewsStatus.loading),
    );
    await ApiService.getMethod(
      endPoint: 'Comment/GetCommentsForProduct/${event.productId}',
    ).then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          getProductReviewsStatus: GetProductReviewsStatus.success,
          productReviewsResponseModel: productReviewsResponseModelFromJson(
            response.data,
          ),
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getProductReviewsStatus: GetProductReviewsStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          getProductReviewsStatus: GetProductReviewsStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onAddReviewToProductEvent(
    AddReviewToProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      state.copyWith(addProductReviewStatus: AddProductReviewStatus.loading),
    );
    await ApiService.postMethod(
      endPoint: 'Comment/addcomment',
      body: {"productId": event.productId, "text": event.comment},
    ).then((response) {
      log(response.data.toString());
      add(GetProductReviewsEvent(productId: event.productId));
      emit(
        state.copyWith(
          addProductReviewStatus: AddProductReviewStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          addProductReviewStatus: AddProductReviewStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          addProductReviewStatus: AddProductReviewStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onAddToFavoritesEvent(
    AddToFavoritesEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final Map<int, FavoriteTransactionStatus> statuses = Map.of(
      state.favoriteTransactionStatus,
    );
    statuses[event.productId] = FavoriteTransactionStatus.loading;
    emit(state.copyWith(favoriteTransactionStatus: statuses));
    await ApiService.postMethod(
      endPoint: 'favorites',
      body: {
        "product_id": event.productId,
        "size": event.size,
        "color": event.color,
        "quantity": event.quantity,
      },
    ).then((response) {
      log(response.data.toString());
      add(GetFavoriteProductsEvent());
      final Map<int, FavoriteTransactionStatus> statuses = Map.of(
        state.favoriteTransactionStatus,
      );
      statuses[event.productId] = FavoriteTransactionStatus.success;
      emit(state.copyWith(favoriteTransactionStatus: statuses));
    }).catchError((error) {
      print(error);
      final Map<int, FavoriteTransactionStatus> statuses = Map.of(
        state.favoriteTransactionStatus,
      );
      statuses[event.productId] = FavoriteTransactionStatus.failure;
      emit(
        state.copyWith(
          favoriteTransactionStatus: statuses,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      final Map<int, FavoriteTransactionStatus> statuses = Map.of(
        state.favoriteTransactionStatus,
      );
      statuses[event.productId] = FavoriteTransactionStatus.failure;
      emit(
        state.copyWith(
          favoriteTransactionStatus: statuses,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onRemoveFromFavoritesEvent(
    RemoveFromFavoritesEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final Map<int, FavoriteTransactionStatus> statuses = Map.of(
      state.favoriteTransactionStatus,
    );
    statuses[event.productId] = FavoriteTransactionStatus.loading;
    emit(state.copyWith(favoriteTransactionStatus: statuses));
    await ApiService.deleteMethod(
      endPoint: 'favorites',
      queryParameters: {"product_id": event.productId.toString()},
    ).then((response) {
      log(response.data.toString());
      add(GetFavoriteProductsEvent());
      final Map<int, FavoriteTransactionStatus> statuses = Map.of(
        state.favoriteTransactionStatus,
      );
      statuses[event.productId] = FavoriteTransactionStatus.success;
      emit(state.copyWith(favoriteTransactionStatus: statuses));
    }).catchError((error) {
      print(error);
      final Map<int, FavoriteTransactionStatus> statuses = Map.of(
        state.favoriteTransactionStatus,
      );
      statuses[event.productId] = FavoriteTransactionStatus.failure;
      emit(
        state.copyWith(
          favoriteTransactionStatus: statuses,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      final Map<int, FavoriteTransactionStatus> statuses = Map.of(
        state.favoriteTransactionStatus,
      );
      statuses[event.productId] = FavoriteTransactionStatus.failure;
      emit(
        state.copyWith(
          favoriteTransactionStatus: statuses,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetProductByIdEvent(
    GetProductByIdEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      state.copyWith(getProductDetailsStatus: GetProductDetailsStatus.loading),
    );
    await ApiService.getMethod(
      endPoint: 'Product/GetDetailsByProduct/${event.productId}',
    ).then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          getProductDetailsStatus: GetProductDetailsStatus.success,
          productDetails: ProductDetailsModel.fromJson(response.data),
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getProductDetailsStatus: GetProductDetailsStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          getProductDetailsStatus: GetProductDetailsStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onSearchProductsEvent(
    SearchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(searchProductsStatus: SearchProductsStatus.loading));
    await ApiService.postMethod(
        endPoint: 'Product/SearchProducts',
        queryParameters: {"query": event.text}).then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          searchProductsStatus: SearchProductsStatus.success,
          searchResult: productsResponseModelFromJson(response.data),
        ),
      );
    }).catchError((error) {
      log(error.toString());
      log(error.response.data.toString());
      emit(
        state.copyWith(
          searchProductsStatus: SearchProductsStatus.failure,
          searchResult: [],
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          searchProductsStatus: SearchProductsStatus.failure,
          searchResult: [],
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onAddSearchHistoryEvent(
    AddSearchHistoryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      state.copyWith(
        searchHistoryTransaction: SearchHistoryTransaction.loading,
      ),
    );
    await ApiService.postMethod(
      endPoint: 'Product/add-search',
      bodyAsString: jsonEncode(event.text),
    ).then((response) {
      add(GetSearchHistoryEvent());
      log(response.data.toString());
    }).catchError((error) {
      log(error.toString());
      log(error.response.data.toString());
      emit(
        state.copyWith(
          searchHistoryTransaction: SearchHistoryTransaction.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          searchHistoryTransaction: SearchHistoryTransaction.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetSearchHistoryEvent(
    GetSearchHistoryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      state.copyWith(
        searchHistoryTransaction: SearchHistoryTransaction.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Product/history').then((response) {
      log(response.data.toString());
      add(GetPopularSearchHistoryEvent());
      emit(
        state.copyWith(
          searchHistory: List<String>.from(
            response.data.map((x) => x),
          ),
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          searchHistoryTransaction: SearchHistoryTransaction.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          searchHistoryTransaction: SearchHistoryTransaction.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetPopularSearchHistoryEvent(
    GetPopularSearchHistoryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      state.copyWith(
        searchHistoryTransaction: SearchHistoryTransaction.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Product/popular').then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          searchHistoryTransaction: SearchHistoryTransaction.success,
          popularSearchHistory: popularSearchResponseModelFromJson(
            response.data,
          ),
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          searchHistoryTransaction: SearchHistoryTransaction.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          searchHistoryTransaction: SearchHistoryTransaction.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onGetFlashSaleEvent(
      GetFlashSaleEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(getFlashSaleStatus: GetFlashSaleStatus.loading));
    await ApiService.getMethod(
      endPoint: 'Product/flash-sale',
    ).then((response) {
      log(response.data.toString());
      try {
        emit(
          state.copyWith(
            getFlashSaleStatus: GetFlashSaleStatus.success,
            flashSale: productsResponseModelFromJson(
              response.data,
            ),
          ),
        );
      }catch(e , st){
        print(e);
        print(st);
      }
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getFlashSaleStatus: GetFlashSaleStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          getFlashSaleStatus: GetFlashSaleStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onClearSearchHistoryEvent(
      ClearSearchHistoryEvent event, Emitter<ProductsState> emit) async {
    emit(
      state.copyWith(
        searchHistoryTransaction: SearchHistoryTransaction.loading,
      ),
    );
    await ApiService.deleteMethod(endPoint: 'Product/history').then((response) {
      log(response.data.toString());
      add(GetPopularSearchHistoryEvent());
      emit(
        state.copyWith(searchHistory: []),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          searchHistoryTransaction: SearchHistoryTransaction.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          searchHistoryTransaction: SearchHistoryTransaction.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onDeleteProductEvent(
      DeleteProductEvent event, Emitter<ProductsState> emit) async {
    emit(
      state.copyWith(
        adminTransactionStatus: AdminTransactionStatus.loading,
      ),
    );
    await ApiService.deleteMethod(endPoint: 'Product/${event.id}')
        .then((response) {
      log(response.data.toString());
      add(GetProductsByCategoryEvent(categoryId: event.categoryId));
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onAddDiscountEvent(
      AddDiscountEvent event, Emitter<ProductsState> emit) async {
    emit(
      state.copyWith(
        adminTransactionStatus: AdminTransactionStatus.loading,
      ),
    );
    await ApiService.postMethod(endPoint: 'Product/AddDiscount', body: {
      "discountPercentage": event.discountPercentage,
      "startDate": event.startDate.toUtc().toIso8601String(),
      "endDate": event.endDate.toUtc().toIso8601String(),
    }).then((response) {
      log(response.data.toString());
      add(GetAllDiscountsEvent());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      log(error.response.toString());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onAddProductEvent(AddProductEvent event, Emitter<ProductsState> emit)  async{

    emit(
      state.copyWith(
        adminTransactionStatus: AdminTransactionStatus.loading,
      ),
    );
    // TODO image

    String fileName = event.image!.path.split('/').last;
    String mimeType = mime(fileName) ?? '';
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    await ApiService.postMethod(
        endPoint: 'Auth/UploadUserImage',
        form: FormData.fromMap({
          "file": await MultipartFile.fromFile(
            event.image!.path,
            filename: fileName,
            contentType: MediaType(mimee, type),
          ),
        })).then((response) async {
      String url = response.data['url'];

      Map<String , dynamic> data = {
        "price": event.price,
        "name": event.name,
        "description": event.description,
        "categoryId" : event.categoryId,
        "gender" : event.gender,
        "imageUrl" : url,
        "quantity" : event.quantity,
        "type" : event.type,
        "season" : event.season,
        "rating" : 0,
        "styleCloth" : event.styleCloth,
        "size" : event.size,
        "color" : event.color,
      };
      if(event.discountId != null){
        data['discountSettingId'] = event.discountId;
      }
    await ApiService.postMethod(endPoint: 'Product', body: data).then((response) {
      log(response.data.toString());
      add(GetProductsByCategoryEvent(categoryId: event.categoryId));
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      log(error.response.toString());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });

  }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
    }

  FutureOr<void> _onEditProductEvent(EditProductEvent event, Emitter<ProductsState> emit)  async {
    emit(
      state.copyWith(
        adminTransactionStatus: AdminTransactionStatus.loading,
      ),
    );

    Map<String, dynamic> data = {
      "id": event.id,
      "price": event.price,
      "name": event.name,
      "description": event.description,
      "categoryId": event.categoryId,
      "gender": event.gender,
      "quantity": event.quantity,
      "type": event.type,
      "season": event.season,
      "styleCloth": event.styleCloth,
      "image": event.image == null ? event.imageUrl : "",
    };
    if (event.discountId != null) {
      data['discountSettingId'] = event.discountId;
    }
if(event.image == null){
  await ApiService.putMethod(endPoint: 'Product', body: {
    "id": event.id,
    "price": event.price,
    "name": event.name,
    "description": event.description,
    "categoryId": event.categoryId,
    "gender": event.gender,
    "quantity": event.quantity,
    "type": event.type,
    "season": event.season,
    "styleCloth": event.styleCloth,
    "image":  event.imageUrl,
  }).then((response) {
    log(response.data.toString());
    add(GetProductsByCategoryEvent(categoryId: event.categoryId));
    emit(
      state.copyWith(
        adminTransactionStatus: AdminTransactionStatus.success,
      ),
    );
  }).catchError((error) {
    log(error.toString());
    emit(
      state.copyWith(
        adminTransactionStatus: AdminTransactionStatus.failure,
        errorMessage: error.response.toString(),
      ),
    );
  }).onError((error, stackTrace) {
    print(error);
    emit(
      state.copyWith(
        adminTransactionStatus: AdminTransactionStatus.failure,
        errorMessage: "حدث خطأ ما!",
      ),
    );
  });
  return;
}
    String fileName = event.image!
        .path
        .split('/')
        .last;
    String mimeType = mime(fileName) ?? '';
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    await ApiService.postMethod(
        endPoint: 'Auth/UploadUserImage',
        form: FormData.fromMap({
          "file": await MultipartFile.fromFile(
            event.image!.path,
            filename: fileName,
            contentType: MediaType(mimee, type),
          ),
        })).then((response) async {
      String url = response.data['url'];
      await ApiService.putMethod(endPoint: 'Product', body: {
        "id": event.id,
        "price": event.price,
        "name": event.name,
        "description": event.description,
        "categoryId": event.categoryId,
        "gender": event.gender,
        "quantity": event.quantity,
        "type": event.type,
        "season": event.season,
        "styleCloth": event.styleCloth,
        "image": event.image == null ? event.imageUrl : url,
      }).then((response) {
        log(response.data.toString());
        add(GetProductsByCategoryEvent(categoryId: event.categoryId));
        emit(
          state.copyWith(
            adminTransactionStatus: AdminTransactionStatus.success,
          ),
        );
      }).catchError((error) {
        log(error.toString());
        emit(
          state.copyWith(
            adminTransactionStatus: AdminTransactionStatus.failure,
            errorMessage: error.response.toString(),
          ),
        );
      }).onError((error, stackTrace) {
        print(error);
        emit(
          state.copyWith(
            adminTransactionStatus: AdminTransactionStatus.failure,
            errorMessage: "حدث خطأ ما!",
          ),
        );
      });
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onDeleteReviewEvent(DeleteReviewEvent event, Emitter<ProductsState> emit)  async{
    emit(
      state.copyWith(addProductReviewStatus: AddProductReviewStatus.loading),
    );
    await ApiService.deleteMethod(
      endPoint: 'Comment/${event.reviewId}',
    ).then((response) {
      log(response.data.toString());
      add(GetProductReviewsEvent(productId: event.productId));
      emit(
        state.copyWith(
          addProductReviewStatus: AddProductReviewStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          addProductReviewStatus: AddProductReviewStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          addProductReviewStatus: AddProductReviewStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });

  }

  FutureOr<void> _onEditReviewToProductEvent(EditReviewToProductEvent event, Emitter<ProductsState> emit) async{
    emit(
      state.copyWith(addProductReviewStatus: AddProductReviewStatus.loading),
    );
    await ApiService.putMethod(

      endPoint: 'Comment/UpdateComment/${event.reviewId}',
      bodyAsString: jsonEncode(event.comment),
    ).then((response) {
      log(response.data.toString());
      add(GetProductReviewsEvent(productId: event.productId));
      emit(
        state.copyWith(
          addProductReviewStatus: AddProductReviewStatus.success,
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          addProductReviewStatus: AddProductReviewStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          addProductReviewStatus: AddProductReviewStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });

  }

  FutureOr<void> _onFilteringEvent(FilteringEvent event, Emitter<ProductsState> emit) async{
    emit(state.copyWith(searchProductsStatus: SearchProductsStatus.loading));
    Map<String , dynamic> data = {};
    if(event.min != null){
      data['minPrice'] = event.min;
    }
    if(event.max != null){
      data['maxPrice'] = event.max;
    }
    if(event.style != null){
      data['styleCloth'] = event.style;
    }
    if(event.size != null){
      data['size'] = event.size;
    }
    if(event.color != null){
      data['color'] = event.color;
    }
    await ApiService.postMethod(
        endPoint: 'Product/SearchProductsAdvanced',
      body: data
        ).then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          searchProductsStatus: SearchProductsStatus.success,
          searchResult: productsResponseModelFromJson(response.data),
        ),
      );
    }).catchError((error) {
      log(error.toString());
      log(error.response.data.toString());
      emit(
        state.copyWith(
          searchProductsStatus: SearchProductsStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          searchProductsStatus: SearchProductsStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });

  }

  FutureOr<void> _onGetAllDiscountsEvent(GetAllDiscountsEvent event, Emitter<ProductsState> emit)  async{
    emit(
      state.copyWith(
        adminTransactionStatus: AdminTransactionStatus.loading,
      ),
    );
    await ApiService.getMethod(endPoint: 'Product/GetAllDiscount').then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.success,
          discounts: discountsResponseModelFromJson(response.data)
        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });
  }

  FutureOr<void> _onDeleteDiscountEvent(DeleteDiscountEvent event, Emitter<ProductsState> emit) async{
    emit(
      state.copyWith(
        adminTransactionStatus: AdminTransactionStatus.loading,
      ),
    );
    await ApiService.deleteMethod(endPoint: 'Product/DeleteDiscount' , queryParameters: {
      "id": event.id.toString()
    }).then((response) {
      log(response.data.toString());
      add(GetAllDiscountsEvent());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.success,

        ),
      );
    }).catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: error.response.toString(),
        ),
      );
    }).onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          adminTransactionStatus: AdminTransactionStatus.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });

  }
}
