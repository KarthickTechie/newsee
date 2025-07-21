import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Utils/masterversioncheck.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/feature/masters/domain/modal/master_request.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/feature/masters/domain/modal/master_version.dart';
import 'package:newsee/feature/masterupdate/data/repository/master_update_repo_impl.dart';
import 'package:newsee/feature/masterupdate/domain/repository/master_update_repository.dart';

part 'master_update_event.dart';
part 'master_update_state.dart';

class MasterUpdateBloc extends Bloc<MasterUpdateEvent, MasterUpdateState> {
  MasterUpdateBloc():super(MasterUpdateState.init()) {
    on<MasterVersionCheck>(masterVersionCheck);
  }

  masterVersionCheck(MasterVersionCheck event, Emitter emit) async {
    try {
      if (Globalconfig.masterUpdate) {
        Globalconfig.masterUpdate = false;
        emit(
            state.copyWith(
              status: SaveStatus.init,
              masterDifferent: false,
              listOfMaster: [],
            )
          );
      } else {
        emit(state.copyWith(status: SaveStatus.loading));
        MasterUpdateRepository masterUpdateRepository = MasterUpdateRepoImpl();
        var masterVersionResponse = await masterUpdateRepository.getMastersVersion();
        if (masterVersionResponse.isRight()) {
          AsyncResponseHandler<bool, List<MasterVersion>>
          masterVersionCheckResponseHandler = await compareVersions(
            Globalconfig.masterVersionMapper,
          );

          if (masterVersionCheckResponseHandler.isRight()) {
            if (masterVersionCheckResponseHandler.right.isNotEmpty) {
              emit(
                state.copyWith(
                  status: SaveStatus.success,
                  masterDifferent: true,
                  listOfMaster: masterVersionCheckResponseHandler.right
                )
              );
            } else {
              emit(
                state.copyWith(
                  status: SaveStatus.success,
                  masterDifferent: false,
                  listOfMaster: []
                )
              );
            }
          } else {
            emit(
              state.copyWith(
                status: SaveStatus.success,
                masterDifferent: false,
                listOfMaster: []
              )
            );
          }
        
        } else {
          emit(
            state.copyWith(
              status: SaveStatus.failure,
              masterDifferent: false,
              listOfMaster: [],
              errorMessage: masterVersionResponse.left.message
            )
          );
        }
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: SaveStatus.failure,
          masterDifferent: false,
          listOfMaster: [],
          errorMessage: error.toString()
        )
      );
    }
  }
}