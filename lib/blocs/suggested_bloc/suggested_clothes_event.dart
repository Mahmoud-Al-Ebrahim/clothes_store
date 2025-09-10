part of 'suggested_clothes_bloc.dart';

@immutable
sealed class SuggestedClothesEvent {}


class GetClothesPerEventType extends SuggestedClothesEvent {
  final String eventType;

  GetClothesPerEventType({
    required this.eventType,
  });
}

class GetSuggestedClothesEvent extends SuggestedClothesEvent {
  final int productId;

  GetSuggestedClothesEvent({
    required this.productId,
  });
}