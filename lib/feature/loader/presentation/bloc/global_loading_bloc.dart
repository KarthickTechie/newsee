import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_state.dart';

class GlobalLoadingBloc extends Bloc<GlobalLoadingEvent, GlobalLoadingState> {
  GlobalLoadingBloc()
    : super(GlobalLoadingState(isLoading: false, message: "")) {
    on<ShowLoading>(
      (event, emit) =>
          emit(state.copyWith(isLoading: true, message: event.message)),
    );
    on<HideLoading>(
      (event, emit) => emit(state.copyWith(isLoading: false, message: "")),
    );
  }
}
