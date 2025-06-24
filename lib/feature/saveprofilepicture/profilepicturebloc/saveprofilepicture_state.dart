part of 'saveprofilepicture_bloc.dart';

enum LeadStatus { init, loading, success, failure, reset }

final class ProfilPictureState extends Equatable {
  final LeadStatus? status;
  final ProfilePictureDetails? profilepicturedetails;

  ProfilPictureState({
    required this.status,
    required this.profilepicturedetails,
  });

  @override
  List<Object?> get props => [status, profilepicturedetails];
}

final class ProfilPictureInitState extends ProfilPictureState {
  ProfilPictureInitState({
    required super.status,
    required super.profilepicturedetails,
  });
}

// final class ProfilPictureDatasetState extends ProfilPictureState {
//   ProfilPictureDatasetState({
//     required super.status,
//     required super.profilepicturedetails,
//   });
// }
