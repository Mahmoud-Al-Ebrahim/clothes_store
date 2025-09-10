import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(const StoreState()) {
    on<StoreEvent>((event, emit) {});
    on<ChangeThemeModeEvent>(_onChangeThemeModeEvent);
  }

  FutureOr<void> _onChangeThemeModeEvent(ChangeThemeModeEvent event, Emitter<StoreState> emit) {
    emit(state.copyWith(
        mode: event.mode
    ));
  }

}
