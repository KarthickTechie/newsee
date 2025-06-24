import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/saveprofilepicture/repository/model/profilepicturedetails.dart';
part 'saveprofilepicture_event.dart';
part 'saveprofilepicture_state.dart';

class SaveProfilePictureBloc
    extends Bloc<ProfilPictureEvent, ProfilPictureState> {
  SaveProfilePictureBloc(super.initialState) {
    on<ProilePictureSaveEvent>(saveCustomerImage);
    on<ResetProfileDataEvent>(resetCustomerImage);
  }

  Future<void> saveCustomerImage(
    ProilePictureSaveEvent event,
    Emitter emit,
  ) async {
    print("saveCustomerImage: => $event");
    ProfilePictureDetails response = ProfilePictureDetails(
      imageData: event.profilebytes,
      leadID: '0001',
    );
    emit(
      ProfilPictureState(
        status: LeadStatus.success,
        profilepicturedetails: response,
      ),
    );
  }

  Future<void> resetCustomerImage(
    ResetProfileDataEvent event,
    Emitter emit,
  ) async {
    print("Reset the customer Image Bloc functionalty works here");
    emit(
      ProfilPictureState(status: LeadStatus.reset, profilepicturedetails: null),
    );
  }

  @override
  Future<void> close() {
    // Clean up resources (e.g., stream subscriptions) if any
    return super.close();
  }
}
