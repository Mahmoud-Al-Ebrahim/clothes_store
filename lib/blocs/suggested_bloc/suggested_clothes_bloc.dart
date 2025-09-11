import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../models/products_of_event_response_model.dart';
import '../../models/suggested_products_response_model.dart';
import '../../utils/api_service.dart';

part 'suggested_clothes_event.dart';

part 'suggested_clothes_state.dart';

class SuggestedClothesBloc
    extends Bloc<SuggestedClothesEvent, SuggestedClothesState> {
  SuggestedClothesBloc() : super(SuggestedClothesState()) {
    on<SuggestedClothesEvent>((event, emit) {});

    on<GetClothesPerEventType>(_onGetClothesPerEventType);
    on<GetSuggestedClothesEvent>(_onGetSuggestedClothesEvent);
  }

  FutureOr<void> _onGetClothesPerEventType(
    GetClothesPerEventType event,
    Emitter<SuggestedClothesState> emit,
  ) async {
    Map<String, GetProductStatus> statuses = Map.of(
      state.productsPerEventTypeStatus,
    );
    // if (statuses[event.eventType] == GetProductStatus.success) return;

    statuses[event.eventType] = GetProductStatus.loading;

    emit(state.copyWith(productsPerEventTypeStatus: statuses));

    await ApiService.getMethod(
          endPoint: 'Clothing/Get${event.eventType}Clothes',
        )
        .then((response) {
          Map<String, GetProductStatus> statuses = Map.of(
            state.productsPerEventTypeStatus,
          );
          statuses[event.eventType] = GetProductStatus.success;
          Map<String, List<ProductsOfEventResponseModel>> data = Map.of(
            state.productsPerEventType,
          );
          log(response.data.toString());
          data[event.eventType] = productsOfEventResponseModelFromJson(
            response.data,
          );
          emit(
            state.copyWith(
              productsPerEventTypeStatus: statuses,
              productsPerEventType: data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          Map<String, GetProductStatus> statuses = Map.of(
            state.productsPerEventTypeStatus,
          );
          statuses[event.eventType] = GetProductStatus.success;
          emit(
            state.copyWith(
              productsPerEventTypeStatus: statuses,
              errorMessage: error.response.toString(),
            ),
          );
        })
        .onError((error, stackTrace) {
          print(error);
          Map<String, GetProductStatus> statuses = Map.of(
            state.productsPerEventTypeStatus,
          );
          statuses[event.eventType] = GetProductStatus.success;
          emit(
            state.copyWith(
              productsPerEventTypeStatus: statuses,
              errorMessage: "حدث خطأ ما!",
            ),
          );
        });
  }

  FutureOr<void> _onGetSuggestedClothesEvent(
    GetSuggestedClothesEvent event,
    Emitter<SuggestedClothesState> emit,
  ) async {

    emit(
      state.copyWith(getSuggestedProducts: GetSuggestedProducts.loading),
    );
    print('id  ${event.productId}');
    await ApiService.getMethod(
      endPoint: 'Clothing/GetSuggestOfClothes',
      queryParameters: {
        "id" : event.productId.toString()
      }
    )
        .then((response) {
      log(response.data.toString());
      emit(
        state.copyWith(
          getSuggestedProducts: GetSuggestedProducts.success,
          suggestedProducts: suggestedProductsResponseModelFromJson(
            response.data,
          ),
        ),
      );
    })
        .catchError((error) {
      log(error.toString());
      emit(
        state.copyWith(
          getSuggestedProducts: GetSuggestedProducts.failure,
          errorMessage: error.response.toString(),
        ),
      );
    })
        .onError((error, stackTrace) {
      print(error);
      emit(
        state.copyWith(
          getSuggestedProducts: GetSuggestedProducts.failure,
          errorMessage: "حدث خطأ ما!",
        ),
      );
    });

  }
}
