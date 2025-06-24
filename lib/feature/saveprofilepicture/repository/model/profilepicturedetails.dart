import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ProfilePictureDetails extends Equatable {
  final Uint8List imageData;
  final String leadID;

  ProfilePictureDetails({required this.leadID, required this.imageData});

  ProfilePictureDetails copyWith({Uint8List? imageData, String? leadID}) {
    return ProfilePictureDetails(
      imageData: imageData ?? this.imageData,
      leadID: leadID ?? this.leadID,
    );
  }

  @override
  List<Object?> get props => [imageData, leadID];
}
