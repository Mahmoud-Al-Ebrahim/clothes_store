part of 'orders_bloc.dart';

enum OrdersTransactionStatus { init, loading, success, failure }

enum GetOrdersStatus { init, loading, success, failure }

class OrdersState {
  final OrdersTransactionStatus ordersTransactionStatus;
  final GetOrdersStatus getOrdersStatus;

  final String errorMessage;
  final OrdersResponseModel? ordersResponseModel;

  OrdersState({
    this.getOrdersStatus = GetOrdersStatus.init,
    this.ordersTransactionStatus = OrdersTransactionStatus.init,
    this.errorMessage = '',
    this.ordersResponseModel,
  });

  OrdersState copyWith({
    final OrdersTransactionStatus? ordersTransactionStatus,
    final GetOrdersStatus? getOrdersStatus,
    final String? errorMessage,
    final OrdersResponseModel? ordersResponseModel,
  }) {
    return OrdersState(
      getOrdersStatus: getOrdersStatus ?? this.getOrdersStatus,
      ordersTransactionStatus:
          ordersTransactionStatus ?? this.ordersTransactionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      ordersResponseModel: ordersResponseModel ?? this.ordersResponseModel,
    );
  }
}
