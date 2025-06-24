part of 'saveprofilepicture_bloc.dart';

sealed class ProfilPictureEvent {}

final class ProilePictureSaveEvent extends ProfilPictureEvent {
  final Uint8List profilebytes;
  ProilePictureSaveEvent(this.profilebytes);
}

final class ResetProfileDataEvent extends ProfilPictureEvent {}
