part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class GetCartEvent extends CartEvent {}

class AddItemToCartEvent extends CartEvent {
  final int productId;
  final int quantity;
  final String size;
  final String color;

  AddItemToCartEvent({
    required this.productId,
    required this.quantity,
    required this.size,
    required this.color,
  });
}

class UpdateItemInCartEvent extends CartEvent {
  final int productId;
  final int quantity;

  UpdateItemInCartEvent({
    required this.productId,
    required this.quantity,
  });
}


class CheckOutEvent extends CartEvent {

  CheckOutEvent();
}
