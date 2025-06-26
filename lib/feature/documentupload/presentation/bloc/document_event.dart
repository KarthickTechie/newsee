import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
  final BuildContext context;
  final int index;
  final String docName;
  final FileSource source;

  AttachFileEvent(
    this.context,
    this.index,
    this.docName, {
    required this.source,
  });
}

class ViewImageEvent extends DocumentEvent {
  final int index;
  final List<DocumentImage> images;
  ViewImageEvent(this.index, this.images);
}

class DeleteDocEvent extends DocumentEvent {
  final int docIndex;
  final int? imgIndex;
  // final DocumentModel doc;
  DeleteDocEvent({required this.docIndex, this.imgIndex});
}

class UploadDocumentsEvent extends DocumentEvent {
  final BuildContext? context;
  final int docIndex;
  final List<int>? imgIndex;
  UploadDocumentsEvent({this.context, required this.docIndex, this.imgIndex});
}
