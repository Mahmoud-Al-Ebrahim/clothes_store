import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:clothes_store/models/orders_response_model.dart';

import '../../utils/api_service.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersState()) {
    on<OrdersEvent>((event, emit) {});
    on<GetMyOrdersEvent>(_onGetMyOrdersEvent);
    on<CancelOrderEvent>(_onCancelOrderEvent);
    on<CreateOrderEvent>(_onCreateOrderEvent);
  }

  FutureOr<void> _onGetMyOrdersEvent(
      GetMyOrdersEvent event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(getOrdersStatus: GetOrdersStatus.loading));
    await ApiService.getMethod(endPoint: 'my-orders').then((response) {
      log(response.data.toString());
      emit(state.copyWith(
          getOrdersStatus: GetOrdersStatus.success,
          ordersResponseModel: OrdersResponseModel.fromJson(response.data)));
    }).catchError((error) {
      print(error);
      emit(state.copyWith(
          getOrdersStatus: GetOrdersStatus.failure,
          errorMessage: error.response.data['message']));
    }).onError((error, stackTrace) {
      print(error);
      emit(state.copyWith(
          getOrdersStatus: GetOrdersStatus.failure,
          errorMessage: "Something went wrong!"));
    });
  }

  FutureOr<void> _onCancelOrderEvent(
      CancelOrderEvent event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(
        ordersTransactionStatus: OrdersTransactionStatus.loading));
    await ApiService.postMethod(endPoint: 'orders/${event.orderId}/cancel')
        .then((response) {
      add(GetMyOrdersEvent());
      log(response.data.toString());
      emit(state.copyWith(
        ordersTransactionStatus: OrdersTransactionStatus.success,
      ));
    }).catchError((error) {
      print(error);
      emit(state.copyWith(
          ordersTransactionStatus: OrdersTransactionStatus.failure,
          errorMessage: error.response.data['message']));
    }).onError((error, stackTrace) {
      print(error);
      emit(state.copyWith(
          ordersTransactionStatus: OrdersTransactionStatus.failure,
          errorMessage: "Something went wrong!"));
    });
  }

  FutureOr<void> _onCreateOrderEvent(
      CreateOrderEvent event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(
        ordersTransactionStatus: OrdersTransactionStatus.loading));
    await ApiService.postMethod(endPoint: 'orders', body: {
      "full_name": event.fullName,
      "phone_number": event.phone,
      "shipping_co": event.shippingCompany,
      "shipping_state": event.shippingState,
      "shipping_branch": event.shippingBranch,
      "items": event.items
    }).then((response) {
      add(GetMyOrdersEvent());
      log(response.data.toString());
      emit(state.copyWith(
        ordersTransactionStatus: OrdersTransactionStatus.success,
      ));
    }).catchError((error) {
      print(error);
      print(error.response);
      print(error.response.data);
      emit(state.copyWith(
          ordersTransactionStatus: OrdersTransactionStatus.failure,
          errorMessage: error.response.data['message']));
    }).onError((error, stackTrace) {
      print(error);
      emit(state.copyWith(
          ordersTransactionStatus: OrdersTransactionStatus.failure,
          errorMessage: "Something went wrong!"));
    });
  }
}
