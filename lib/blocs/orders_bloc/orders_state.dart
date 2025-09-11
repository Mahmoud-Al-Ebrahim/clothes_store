part of 'orders_bloc.dart';

enum OrdersTransactionStatus { init, loading, success, failure }

enum GetOrdersStatus { init, loading, success, failure }

class OrdersState {
  final OrdersTransactionStatus ordersTransactionStatus;
  final GetOrdersStatus getOrdersStatus;

  final String errorMessage;
  final List<OrdersResponseModel> orders;

  OrdersState({
    this.getOrdersStatus = GetOrdersStatus.init,
    this.ordersTransactionStatus = OrdersTransactionStatus.init,
    this.errorMessage = '',
    this.orders = const [],
  });

  OrdersState copyWith({
    final OrdersTransactionStatus? ordersTransactionStatus,
    final GetOrdersStatus? getOrdersStatus,
    final String? errorMessage,
    final List<OrdersResponseModel>? orders,
  }) {
    return OrdersState(
      getOrdersStatus: getOrdersStatus ?? this.getOrdersStatus,
      ordersTransactionStatus:
          ordersTransactionStatus ?? this.ordersTransactionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      orders: orders ?? this.orders,
    );
  }
}
