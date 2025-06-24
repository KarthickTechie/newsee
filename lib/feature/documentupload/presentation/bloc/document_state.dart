import 'package:equatable/equatable.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_type_model.dart';

class DocumentState extends Equatable {
  final List<DocumentTypeModel> docTypeList;
  final List<DocumentModel> borrowerDocs;
  final String? selectedDocType;
  final bool disableBtn;
  final bool uploadBtn;

  const DocumentState({
    this.docTypeList = const [],
    this.borrowerDocs = const [],
    this.selectedDocType,
    this.disableBtn = false,
    this.uploadBtn = false,
  });

  DocumentState copyWith({
    List<DocumentTypeModel>? docTypeList,
    List<DocumentModel>? borrowerDocs,
    String? selectedDocType,
    bool? disableBtn,
    bool? uploadBtn,
  }) {
    return DocumentState(
      docTypeList: docTypeList ?? this.docTypeList,
      borrowerDocs: borrowerDocs ?? this.borrowerDocs,
      selectedDocType: selectedDocType ?? this.selectedDocType,
      disableBtn: disableBtn ?? this.disableBtn,
      uploadBtn: uploadBtn ?? this.uploadBtn,
    );
  }

  @override
  List<Object?> get props => [
    docTypeList,
    borrowerDocs,
    selectedDocType,
    disableBtn,
    uploadBtn,
  ];
}
