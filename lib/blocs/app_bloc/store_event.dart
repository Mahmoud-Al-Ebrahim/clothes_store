part of 'store_bloc.dart';

@immutable
sealed class StoreEvent {}



class ChangeThemeModeEvent extends StoreEvent{
  final ThemeMode mode;
  ChangeThemeModeEvent({required this.mode});
}