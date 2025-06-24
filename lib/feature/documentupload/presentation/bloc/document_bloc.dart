import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_type_model.dart';
import 'package:path/path.dart' as p;
import 'package:reactive_forms/reactive_forms.dart';
import 'document_event.dart';
import 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  // final formKey = GlobalKey<FormState>();
  late FormGroup formKey;

  DocumentBloc() : super(const DocumentState()) {
    on<FetchDocTypesEvent>(_onFetchDocTypes);
    on<SelectDocTypeEvent>(_onSelectDocType);
    on<AddDocEvent>(_onAddDoc);
    on<AttachFileEvent>(_onAttachFile);
    on<DeleteDocEvent>(_onDeleteDoc);
    on<UploadDocumentsEvent>(_onUploadDocuments);
  }

  void _onFetchDocTypes(FetchDocTypesEvent event, Emitter<DocumentState> emit) {
    final types = [
      DocumentTypeModel(code: "1", desc: "KYC Document"),
      DocumentTypeModel(code: "2", desc: "Income Proof"),
    ];
    emit(state.copyWith(docTypeList: types));
  }

  void _onSelectDocType(SelectDocTypeEvent event, Emitter<DocumentState> emit) {
    emit(state.copyWith(selectedDocType: event.selectedCode));
  }

  void _onAddDoc(AddDocEvent event, Emitter<DocumentState> emit) {
    print('AddDocEvent triggered: $formKey');
    print(
      'AddDocEvent triggered: ${formKey.control('docClassification').value}',
    );
    // if (!isFormValid()) return;

    final selectedCode = state.selectedDocType;
    final exists = state.borrowerDocs.any(
      (doc) =>
          doc.prdDocDesc ==
          state.docTypeList.firstWhere((e) => e.code == selectedCode).desc,
    );

    // check duplicates
    if (exists) return;

    final docType = state.docTypeList.firstWhere(
      (doc) => doc.code == selectedCode,
    );

    final newDoc = DocumentModel(prdDocDesc: docType.desc, imgs: []);
    final updatedDocs = [...state.borrowerDocs, newDoc];

    emit(state.copyWith(borrowerDocs: updatedDocs, uploadBtn: true));
  }

  void _onDeleteDoc(DeleteDocEvent event, Emitter<DocumentState> emit) {
    final updatedDocs = [...state.borrowerDocs]..removeAt(event.index);
    emit(
      state.copyWith(
        borrowerDocs: updatedDocs,
        uploadBtn: updatedDocs.isNotEmpty,
      ),
    );
  }

  void _onUploadDocuments(
    UploadDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) {
    // upload
    debugPrint("Uploading documents...");
  }

  bool get disableBtn => state.disableBtn;

  // bool isFormValid() => formKey.currentState?.validate() ?? false;
  bool isFormValid() => formKey.valid;

  void _onAttachFile(AttachFileEvent event, Emitter<DocumentState> emit) async {
    try {
      String? fileName;
      double? fileSize;
      File? file;

      if (event.source == FileSource.camera ||
          event.source == FileSource.gallery) {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source:
              event.source == FileSource.camera
                  ? ImageSource.camera
                  : ImageSource.gallery,
        );

        if (picked != null) {
          file = File(picked.path);
          // fileName = file.path.split('/').last;
          final ext = p.extension(file.path).toLowerCase();
          fileName = '${event.docName}_${event.index}$ext';
          fileSize = await file.length() / (1024 * 1024);
        }
      } else if (event.source == FileSource.pdf) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null && result.files.isNotEmpty) {
          final pickedFile = result.files.first;
          fileName = pickedFile.name;
          fileSize = pickedFile.size / (1024 * 1024);
          file = File(pickedFile.path!);
        }
      }

      if (fileName != null && fileSize != null && file != null) {
        final docs = [...state.borrowerDocs];
        final updatedImgs = [...docs[event.index].imgs];

        updatedImgs.add(
          DocumentImage(
            name: fileName,
            size: double.parse(fileSize.toStringAsFixed(2)),
            path: file.path,
          ),
        );

        docs[event.index] = DocumentModel(
          prdDocDesc: docs[event.index].prdDocDesc,
          imgs: updatedImgs,
        );

        emit(state.copyWith(borrowerDocs: docs));
      }
    } catch (e) {
      print('Error attaching file: $e');
    }
  }
}
