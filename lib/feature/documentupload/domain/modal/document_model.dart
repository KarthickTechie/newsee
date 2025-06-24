class DocumentImage {
  final String name;
  final double size;
  final String path;

  DocumentImage({required this.name, required this.size, required this.path});
}

class DocumentModel {
  final String prdDocDesc;
  final List<DocumentImage> imgs;

  DocumentModel({required this.prdDocDesc, required this.imgs});
}
