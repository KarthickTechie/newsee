import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/masters/domain/modal/master_request.dart';
import 'package:newsee/feature/masters/domain/modal/master_response.dart';
import 'package:newsee/feature/masters/domain/modal/master_types.dart';
import 'package:newsee/feature/masters/domain/repository/master_repo.dart';

part './masters_event.dart';
part './masters_state.dart';

class MastersBloc extends Bloc<MastersEvent, MastersState> {
  final MasterRepo masterRepo;
  MastersBloc({required this.masterRepo, required MastersState initState})
    : super(initState) {
    on<MasterFetch>(onMasterFetch);
  }

  Future<void> onMasterFetch(MasterFetch event, Emitter emit) async {
    emit(state.copyWith(status: MasterdownloadStatus.loading));
    AsyncResponseHandler<Failure, MasterResponse> responseHandler =
        await masterRepo.downloadMaster(request: event.request);

    if (responseHandler.isRight()) {
      emit(
        state.copyWith(
          status:
              responseHandler.right.masterType == MasterTypes.success
                  ? MasterdownloadStatus.success
                  : MasterdownloadStatus.loading,
          masterResponse: responseHandler.right,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: MasterdownloadStatus.failue,
          errorMsg: responseHandler.left.message,
        ),
      );
    }
  }
}
