import 'package:equatable/equatable.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';

abstract class DocumentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDocTypesEvent extends DocumentEvent {}

class SelectDocTypeEvent extends DocumentEvent {
  final String selectedCode;
  SelectDocTypeEvent(this.selectedCode);
}

class AddDocEvent extends DocumentEvent {}

// class AttachFileEvent extends DocumentEvent {
//   final int index;
//   AttachFileEvent(this.index);
// }

enum FileSource { camera, gallery, pdf }

class AttachFileEvent extends DocumentEvent {
  final int index;
  final String docName;
  final FileSource source;

  AttachFileEvent(this.index, this.docName, {required this.source});
}

class ViewImageEvent extends DocumentEvent {
  final int index;
  final List<DocumentImage> images;
  ViewImageEvent(this.index, this.images);
}

class DeleteDocEvent extends DocumentEvent {
  final int index;
  final DocumentModel doc;
  DeleteDocEvent(this.index, this.doc);
}

class UploadDocumentsEvent extends DocumentEvent {}
