part of 'orders_bloc.dart';

@immutable
sealed class OrdersEvent {}

class GetMyOrdersEvent extends OrdersEvent {}

class CancelOrderEvent extends OrdersEvent { // just for admin
  final int orderId;

  CancelOrderEvent({required this.orderId});
}

class CreateOrderEvent extends OrdersEvent {
  final String fullName;
  final String phone;
  final String shippingCompany;
  final String shippingState;
  final String shippingBranch;
  final List<Map<String, dynamic>> items;

  CreateOrderEvent({
    required this.fullName,
    required this.phone,
    required this.shippingCompany,
    required this.shippingState,
    required this.shippingBranch,
    required this.items,
  });
}
