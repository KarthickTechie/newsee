enum UploadStatus { initial, uploading, success, failed }

class DocumentImage {
  final String name;
  final double size;
  final String path;
  final UploadStatus imgStatus;
  DocumentImage({
    required this.name,
    required this.size,
    required this.path,
    this.imgStatus = UploadStatus.initial,
  });

  DocumentImage copyWith({UploadStatus? imgStatus}) {
    return DocumentImage(
      name: name,
      size: size,
      path: path,
      imgStatus: imgStatus ?? this.imgStatus,
    );
  }
}

class DocumentModel {
  // final String leadId;
  final String prdDocDesc;
  final List<DocumentImage> imgs;

  DocumentModel({required this.prdDocDesc, required this.imgs});
}
