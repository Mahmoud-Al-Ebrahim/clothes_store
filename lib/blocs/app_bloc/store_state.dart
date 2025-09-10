part of 'store_bloc.dart';

@immutable
 class StoreState {
  const StoreState({
    this.mode = ThemeMode.light,
    this.currentIndex = 0,
  });

  final ThemeMode mode;
  final int currentIndex;

  StoreState copyWith({
    ThemeMode? mode,
    int? currentIndex,
  }) {
    return StoreState(
      mode: mode ?? this.mode,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}