part of 'cart_bloc.dart';

enum CartTransactionStatus { init, loading, success, failure }

enum GetCartStatus { init, loading, success, failure }

enum CheckoutStatus { init, loading, success, failure }

class CartState {
  final CartTransactionStatus cartTransactionStatus;
  final GetCartStatus getCartStatus;
  final CheckoutStatus checkoutStatus;
  final String errorMessage;

  final List<GetCartResponseModel>? cartResponseModel;

  CartState({
    this.getCartStatus = GetCartStatus.init,
    this.cartTransactionStatus = CartTransactionStatus.init,
    this.checkoutStatus = CheckoutStatus.init,
    this.errorMessage = '',
    this.cartResponseModel,
  });

  CartState copyWith({
    final CartTransactionStatus? cartTransactionStatus,
    final GetCartStatus? getCartStatus,
    final String? errorMessage,
    final CheckoutStatus? checkoutStatus,
    final List<GetCartResponseModel>? cartResponseModel,
  }) {
    return CartState(
      cartResponseModel: cartResponseModel ?? this.cartResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
      getCartStatus: getCartStatus ?? this.getCartStatus,
      checkoutStatus: checkoutStatus ?? this.checkoutStatus,
      cartTransactionStatus:
          cartTransactionStatus ?? this.cartTransactionStatus,
    );
  }
}
