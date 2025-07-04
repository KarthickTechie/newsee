import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum FileSource { camera, gallery, pdf }

abstract class DocumentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Fetch document types and initial list
class FetchDocumentsEvent extends DocumentEvent {
  final String proposalNumber;
  FetchDocumentsEvent({required this.proposalNumber});

  @override
  List<Object?> get props => [proposalNumber];
}

// Attach image or file from camera/gallery/pdf
class AttachImageEvent extends DocumentEvent {
  final BuildContext context;
  final int docIndex;
  final String docName;
  final FileSource source;

  AttachImageEvent({
    required this.context,
    required this.docIndex,
    required this.docName,
    required this.source,
  });

  @override
  List<Object?> get props => [docIndex, docName, source];
}

// Delete entire doc image list or a specific index
class DeleteDocumentImageEvent extends DocumentEvent {
  final int docIndex;
  final int? imgIndex; // null = delete all
  DeleteDocumentImageEvent({required this.docIndex, this.imgIndex});

  @override
  List<Object?> get props => [docIndex, imgIndex];
}

// Upload documents for selected image indices
class UploadDocumentByIndexEvent extends DocumentEvent {
  final int docIndex;
  final List<int> imgIndexes;
  UploadDocumentByIndexEvent({
    required this.docIndex,
    required this.imgIndexes,
  });

  @override
  List<Object?> get props => [docIndex, imgIndexes];
}

// Upload document directly from a raw image byte stream
class UploadDocumentByBytesEvent extends DocumentEvent {
  final BuildContext context;
  final int docIndex;
  final Uint8List imageBytes;
  UploadDocumentByBytesEvent({
    required this.context,
    required this.docIndex,
    required this.imageBytes,
  });

  @override
  List<Object?> get props => [docIndex, imageBytes];
}

class FetchDocumentImagesEvent extends DocumentEvent {
  final int docIndex;
  final int imgIndex;
  FetchDocumentImagesEvent({required this.docIndex, required this.imgIndex});
}
