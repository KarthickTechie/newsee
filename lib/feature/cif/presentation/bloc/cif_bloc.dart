import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/cif/data/repository/cif_respository_impl.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_request.dart';
import 'package:newsee/feature/cif/domain/repository/cif_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response_model.dart';
part 'cif_event.dart';
part 'cif_state.dart';

final class CifBloc extends Bloc<CifEvent, CifState> {
  CifBloc() : super(CifState()) {
    on<SearchingCifEvent>(_onSearchCif);
  }

  Future _onSearchCif(SearchingCifEvent event, Emitter<CifState> emit) async {
    emit(state.copyWith(status: CifStatus.loading));
    CifRepository dedupeRepository = CifRepositoryImpl();
    final response = await dedupeRepository.searchCif(event.request);
    if (response.isRight()) {
      emit(
        state.copyWith(
          status: CifStatus.success,
          // cifResponseModel: response.right,
        ),
      );
    } else {
      print('cif failure response.left ');
      emit(
        state.copyWith(
          status: CifStatus.failure,
          errorMessage: response.left.message,
        ),
      );
    }
  }
}
