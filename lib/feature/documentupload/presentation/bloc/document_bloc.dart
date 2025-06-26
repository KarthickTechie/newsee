import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/Utils/pdf_viewer.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_type_model.dart';
import 'package:path/path.dart' as p;
import 'package:reactive_forms/reactive_forms.dart';
import 'document_event.dart';
import 'document_state.dart';
// import 'package:http/http.dart' as http;

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final getit = MediaService();
  final mediaService = MediaService();

  DocumentBloc() : super(const DocumentState()) {
    on<FetchDocTypesEvent>(_onFetchDocTypes);
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
    final newDoc =
        types.map((doc) {
          return DocumentModel(prdDocDesc: doc.desc, imgs: []);
        }).toList();
    final updatedDocs = newDoc;
    emit(state.copyWith(borrowerDocs: updatedDocs, uploadBtn: true));
  }

  void _onAddDoc(AddDocEvent event, Emitter<DocumentState> emit) {
    final newDoc =
        state.docTypeList.map((doc) {
          return DocumentModel(prdDocDesc: doc.desc, imgs: []);
        }).toList();
    final updatedDocs = newDoc;

    emit(state.copyWith(borrowerDocs: updatedDocs, uploadBtn: true));
  }

  void _onDeleteDoc(DeleteDocEvent event, Emitter<DocumentState> emit) {
    final docs = [...state.borrowerDocs];

    if (event.docIndex < 0 || event.docIndex >= docs.length) return;

    final doc = docs[event.docIndex];
    final images = [...doc.imgs];
    if (event.imgIndex == null) {
      images.clear();
    } else {
      if (event.imgIndex! < 0 || event.imgIndex! >= images.length) return;
      images.removeAt(event.imgIndex!);
    }
    final updatedDoc = DocumentModel(prdDocDesc: doc.prdDocDesc, imgs: images);
    docs[event.docIndex] = updatedDoc;

    emit(
      state.copyWith(
        borrowerDocs: docs,
        uploadBtn: docs.any((d) => d.imgs.isNotEmpty),
      ),
    );
  }

  bool get disableBtn => state.disableBtn;

  void _onAttachFile(AttachFileEvent event, Emitter<DocumentState> emit) async {
    try {
      String? fileName;
      double? fileSize;
      File? file;

      // if (event.source == FileSource.camera ||
      //     event.source == FileSource.gallery) {
      if (event.source == FileSource.camera) {
        final imageBytes = await event.context.pushNamed<Uint8List>("camera");
        print('camimgpath $imageBytes');
        if (imageBytes != null) {
          final imagePath = await mediaService.saveBytesToFile(imageBytes!);
          print('camimg $imageBytes');
          final ext = p.extension(imagePath).toLowerCase();
          final count = state.borrowerDocs[event.index].imgs.length + 1;
          fileName = "${event.docName}_$count.$ext";
          file = File(imagePath);
          fileSize = await file.length() / (1024 * 1024);
        }
      } else if (event.source == FileSource.gallery) {
        final galleyImageBytes = await getit.pickimagefromgallery(
          event.context,
        );
        if (galleyImageBytes != null) {
          print("galleryimgpath $galleyImageBytes");

          final imagePath = await mediaService.saveBytesToFile(
            galleyImageBytes!,
          );
          final ext = p.extension(imagePath).toLowerCase();
          final count = state.borrowerDocs[event.index].imgs.length + 1;
          fileName = "${event.docName}_$count.$ext";
          file = File(imagePath);
          fileSize = await file.length() / (1024 * 1024);
        }
      } else if (event.source == FileSource.pdf) {
        final fileBytes = await getit.filePicker();
        print("fileBytes: $fileBytes");
        if (fileBytes != null) {
          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => PDFViewerFromBytes(filedata: fileBytes),
            ),
          );
        }
      }

      // if (getprofileData != null) {
      //   return getprofileData;
      // } else {
      //   return null;
      // }
      // final picker = ImagePicker();
      // final picked = await picker.pickImage(
      //   source:
      //       event.source == FileSource.camera
      //           ? ImageSource.camera
      //           : ImageSource.gallery,
      // );

      // if (picked != null) {
      //   file = File(picked.path);
      //   // fileName = file.path.split('/').last;
      //   final ext = p.extension(file.path).toLowerCase();
      //   final count = state.borrowerDocs[event.index].imgs.length + 1;
      //   fileName = "${event.docName}_$count.$ext";
      //   fileSize = await file.length() / (1024 * 1024);
      // }
      // } else if (event.source == FileSource.pdf) {
      //   final result = await FilePicker.platform.pickFiles(
      //     type: FileType.custom,
      //     allowedExtensions: ['pdf'],
      //   );

      //   if (result != null && result.files.isNotEmpty) {
      //     final pickedFile = result.files.first;
      //     fileName = pickedFile.name;
      //     fileSize = pickedFile.size / (1024 * 1024);
      //     file = File(pickedFile.path!);
      //   }
      // }

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

  Future<void> _onUploadDocuments(
    UploadDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final docs = [...state.borrowerDocs];
    final docImages = docs[event.docIndex];
    if (event.imgIndex != null && event.imgIndex != []) {
      for (int index in event.imgIndex!) {
        final image = docImages.imgs[index];

        // cheking if already uploading or uploaded
        if (image.imgStatus == UploadStatus.uploading ||
            image.imgStatus == UploadStatus.success)
          continue;

        //  uploading
        docImages.imgs[index] = image.copyWith(
          imgStatus: UploadStatus.uploading,
        );
        docs[event.docIndex] = docImages;
        emit(state.copyWith(borrowerDocs: docs));

        try {
          // call actual upload api
          await uploadImageToServer(image);

          docImages.imgs[index] = image.copyWith(
            imgStatus: UploadStatus.success,
          );
        } catch (e) {
          docImages.imgs[index] = image.copyWith(
            imgStatus: UploadStatus.failed,
          );
        }

        docs[event.docIndex] = docImages;
        emit(state.copyWith(borrowerDocs: docs));
      }
    }
  }

  Future<void> uploadImageToServer(DocumentImage image) async {
    // upload img to api
    // await Future.delayed(Duration(seconds: 2));
  }
}
