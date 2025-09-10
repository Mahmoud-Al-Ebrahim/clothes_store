import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:clothes_store/models/cart_response_model.dart';
import '../../utils/api_service.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<CartEvent>((event, emit) {});
    on<GetCartEvent>(_onGetCartEvent);
    on<AddItemToCartEvent>(_onAddItemToCartEvent);
    on<UpdateItemInCartEvent>(_onUpdateItemInCartEvent);
    on<CheckOutEvent>(_onCheckOutEvent);
  }

  FutureOr<void> _onGetCartEvent(
    GetCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(getCartStatus: GetCartStatus.loading));
    await ApiService.getMethod(endPoint: 'Cart/GetUserCart')
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(
              getCartStatus: GetCartStatus.success,
              cartResponseModel: getCartResponseModelFromJson(response.data),
            ),
          );
        })
        .catchError((error) {
          print(error);
          emit(
            state.copyWith(
              getCartStatus: GetCartStatus.failure,
              errorMessage: error.response.data['message'],
            ),
          );
        })
        .onError((error, stackTrace) {
          print(error);
          emit(
            state.copyWith(
              getCartStatus: GetCartStatus.failure,
              errorMessage: "حدث خطأ ما!",
            ),
          );
        });
  }

  FutureOr<void> _onAddItemToCartEvent(
    AddItemToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(cartTransactionStatus: CartTransactionStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Cart/AddToCart',
          body: {
            "productId": event.productId,
            "quantity": event.quantity,
            "size": event.size,
            "color": event.color,
          },
        )
        .then((response) {
          log(response.data.toString());
          add(GetCartEvent());
          emit(
            state.copyWith(
              cartTransactionStatus: CartTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          print(error);
          emit(
            state.copyWith(
              cartTransactionStatus: CartTransactionStatus.failure,
              errorMessage: error.response.data['message'],
            ),
          );
        })
        .onError((error, stackTrace) {
          print(error);
          emit(
            state.copyWith(
              cartTransactionStatus: CartTransactionStatus.failure,
              errorMessage: "حدث خطأ ما!",
            ),
          );
        });
  }

  FutureOr<void> _onUpdateItemInCartEvent(
    UpdateItemInCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(cartTransactionStatus: CartTransactionStatus.loading));
    await ApiService.putMethod(
          endPoint: 'Cart/UpdateQuantity',
          body: {"productId": event.productId, "quantity": event.quantity},
        )
        .then((response) {
          log(response.data.toString());
          add(GetCartEvent());
          emit(
            state.copyWith(
              cartTransactionStatus: CartTransactionStatus.success,
            ),
          );
        })
        .catchError((error) {
          print(error);
          emit(
            state.copyWith(
              cartTransactionStatus: CartTransactionStatus.failure,
              errorMessage: error.response.data['message'],
            ),
          );
        })
        .onError((error, stackTrace) {
          print(error);
          emit(
            state.copyWith(
              cartTransactionStatus: CartTransactionStatus.failure,
              errorMessage: "حدث خطأ ما!",
            ),
          );
        });
  }


  FutureOr<void> _onCheckOutEvent(
    CheckOutEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(checkoutStatus: CheckoutStatus.loading));
    await ApiService.postMethod(endPoint: 'CheckOut')
        .then((response) {
          log(response.data.toString());
          add(GetCartEvent());
          emit(
            state.copyWith(
              checkoutStatus: CheckoutStatus.success,
              cartResponseModel: [],
            ),
          );
        })
        .catchError((error) {
          print(error);
          emit(
            state.copyWith(
              checkoutStatus: CheckoutStatus.failure,
              errorMessage: error.response.data['message'],
            ),
          );
        })
        .onError((error, stackTrace) {
          print(error);
          emit(
            state.copyWith(
              checkoutStatus: CheckoutStatus.failure,
              errorMessage: "حدث خطأ ما!",
            ),
          );
        });
  }
}
