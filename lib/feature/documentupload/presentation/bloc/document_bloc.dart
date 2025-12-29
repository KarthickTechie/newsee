import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/Utils/pdf_viewer.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/documentupload/data/repository/delete_document_repo_impl.dart';
import 'package:newsee/feature/documentupload/data/repository/get_document_repo_impl.dart';
import 'package:newsee/feature/documentupload/data/repository/get_image_repo_impl.dart';
import 'package:newsee/feature/documentupload/data/repository/upload_document_repo_impl.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_state.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final MediaService mediaService;

  DocumentBloc({required this.mediaService}) : super(DocumentState.initial()) {
    on<FetchDocumentsEvent>(_onFetchDocuments);
    on<AttachImageEvent>(_onAttachImage);
    on<DeleteDocumentImageEvent>(_onDeleteDocumentImage);
    on<UploadDocumentByBytesEvent>(_onUploadDocumentByBytes);
    on<FetchDocumentImagesEvent>(_onFetchDocumentImages);
  }
  Future<void> _onFetchDocuments(
    FetchDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    UserDetails? userDetails = await loadUser();
    emit(
      state.copyWith(
        proposalNumber: event.proposalNumber,
        fetchStatus: SubmitStatus.loading,
      ),
    );
    try {
      final responseHandler = await GetDocumentRepoImpl().getDocuments(
        request: {
          "userid": userDetails!.LPuserID,
          "vertical": "7",
          "token": ApiConfig.AUTH_TOKEN,
          "proposalNumber": event.proposalNumber,
        },
      );

      if (responseHandler.isRight()) {
        final response = responseHandler.right;
        final rawList = response['documentdetails'] as List<dynamic>? ?? [];
        final uploadedImgList =
            response['uploadedDocuments'] as List<dynamic>? ?? [];

        final allImages =
            uploadedImgList
                .map((e) => DocumentImage.fromMap(e as Map<String, dynamic>))
                .toList();

        // group images by docId (assuming there's a `docId` field in both models)
        final Map<String, List<DocumentImage>> imagesByDocId = {};
        for (final image in allImages) {
          imagesByDocId.putIfAbsent(image.docId, () => []).add(image);
        }
        // map documents and attach their respective images
        final documents =
            rawList
                .map((e) => DocumentModel.fromMap(e as Map<String, dynamic>))
                .map((doc) {
                  final matchingImages =
                      allImages.where((img) {
                        return img.docId.toString().startsWith(
                          doc.lpdDocId.toString(),
                        );
                      }).toList();
                  return doc.copyWith(imgs: matchingImages);
                })
                .toList();

        emit(
          state.copyWith(
            documentsList: documents,
            fetchStatus: SubmitStatus.success,
            uploadMessage: "Fetched Documents Successfully",
          ),
        );
      } else {
        emit(
          state.copyWith(
            fetchStatus: SubmitStatus.failure,
            uploadMessage: "Fetched Document failure!",
          ),
        );
      }
    } catch (e) {
      print("Fetch failed: $e");
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.failure,
          uploadMessage: "Fetched failed: $e",
        ),
      );
    }
  }

  Future<void> _onAttachImage(
    AttachImageEvent event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final docs = [...state.documentsList];
      final doc = docs[event.docIndex];
      // final count = doc.imgs.length + 1;
      File? file;

      if (event.source == FileSource.camera) {
        final imageBytes = await event.context.pushNamed<Uint8List>("camera");
        // final filename = '${doc.lpdDocDesc}_${doc.imgs.length + 1}.jpg';
        if (imageBytes != null) {
          await viewImageBeforeUpload(event, imageBytes);
          // final imagePath = await mediaService.saveBytesToFile(
          //   imageBytes,
          //   filename,
          // );
          // file = File(imagePath.path);
        }
      } else if (event.source == FileSource.gallery) {
        final bytes = await mediaService.pickimagefromgallery(
          event.context,
          docIndex: event.docIndex,
        );
        if (bytes != null) {
          await viewImageBeforeUpload(event, bytes);
          // final filename = '${doc.lpdDocDesc}_${doc.imgs.length + 1}.jpg';
          // final imagePath = await mediaService.saveBytesToFile(bytes, filename);
          // file = File(imagePath.path);
        }
      } else if (event.source == FileSource.pdf) {
        final result = await mediaService.filePicker();
        print('fileBytes: $result');
        if (result != null) {
          final uploadClick = await Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (context) => PDFViewerFromBytes(filedata: result),
            ),
          );
          if (uploadClick == true) {
            emit(
              state.copyWith(
                fetchStatus: SubmitStatus.loading,
                uploadMessage: 'Uploading Document...',
              ),
            );
            final pickedFile = result.files.first;
            file = File(pickedFile.path!);
            final uploadedImg = await _uploadFile(file, doc);

            if (uploadedImg != null) {
              final currentList = [...state.documentsList];

              final newImages =
                  uploadedImg.map<DocumentImage>((img) {
                    return DocumentImage(
                      fileName: img['ldaDocName'] ?? '',
                      fileLocation: file!.path,
                      docId: img['ldaDocId']?.toString() ?? '',
                      rowId: img['ldaRowId']?.toString() ?? '',
                    );
                  }).toList();

              currentList[event.docIndex] = doc.copyWith(imgs: newImages);

              emit(
                state.copyWith(
                  documentsList: currentList,
                  fetchStatus: SubmitStatus.success,
                  uploadMessage: "Uploaded Successfully",
                ),
              );
            } else {
              emit(
                state.copyWith(
                  fetchStatus: SubmitStatus.failure,
                  uploadMessage: "Upload failed",
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      print("Attach image error: $e");
      emit(
        state.copyWith(fetchStatus: SubmitStatus.failure, uploadMessage: "$e"),
      );
    }
  }

  Future<void> viewImageBeforeUpload(
    AttachImageEvent event,
    Uint8List imageBytes,
  ) async {
    //preview before upload
    debugPrint("docbloc isUploaded: ${state.isUploading}");
    final result = await event.context.push(
      '/imageview',
      extra: {
        'imageBytes': imageBytes,
        'docIndex': event.docIndex,
        'isUploaded': state.isUploading ?? false,
      },
    );

    if (result != null && result is Uint8List && event.context.mounted) {
      add(
        UploadDocumentByBytesEvent(
          context: event.context,
          docIndex: event.docIndex,
          imageBytes: imageBytes,
        ),
      );
    }
  }

  Future<void> _onDeleteDocumentImage(
    DeleteDocumentImageEvent event,
    Emitter<DocumentState> emit,
  ) async {
    UserDetails? userDetails = await loadUser();

    try {
      final docs = [...state.documentsList];
      final doc = docs[event.docIndex];
      final imgs = [...doc.imgs];
      print(imgs);
      final responseHandler = await DeleteDocumentRepoImpl().deleteUploadedDoc(
        request: {
          "proposalNumber": state.proposalNumber,
          "userid": userDetails!.LPuserID,
          "rowId": imgs[event.imgIndex!].rowId,
          "token": ApiConfig.AUTH_TOKEN,
        },
      );

      if (responseHandler.isRight()) {
        if (event.imgIndex! >= 0 && event.imgIndex! < imgs.length) {
          imgs.removeAt(event.imgIndex!);
        }
        docs[event.docIndex] = doc.copyWith(imgs: imgs);
        emit(
          state.copyWith(
            documentsList: docs,
            fetchStatus: SubmitStatus.success,
            uploadMessage: "Deleted Successfully",
          ),
        );
      } else {
        emit(
          state.copyWith(
            fetchStatus: SubmitStatus.failure,
            uploadMessage: "Delete Document Failed!",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.failure,
          uploadMessage: "Delete Document error: $e",
        ),
      );
      print('Delete Document: $e');
    }
  }

  Future<Uint8List?> convertImageToWebP(String imagePath) async {
    // Read the image file into bytes
    Uint8List originalBytes = await File(imagePath).readAsBytes();

    // Compress the bytes to WebP format
    var result = await FlutterImageCompress.compressWithList(
      originalBytes,
      minHeight: 1080, // Optional: specify min height
      minWidth: 1080, // Optional: specify min width
      quality: 90, // Quality (0-100)
      format: CompressFormat.webp, // Set the format to WebP
    );

    print('Original size: ${originalBytes.length} bytes');
    print('WebP size: ${result.length} bytes');

    return result;
  }

  Future<void> _onUploadDocumentByBytes(
    UploadDocumentByBytesEvent event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.loading,
          uploadMessage: 'Uploading Document...',
        ),
      );
      final docs = [...state.documentsList];
      final doc = docs[event.docIndex];
      final filename = '${doc.lpdDocDesc}_${doc.imgs.length + 1}.jpg';
      final imagePath = await mediaService.saveBytesToFile(
        event.imageBytes,
        filename,
      );
      Uint8List? webpBytes = await convertImageToWebP(imagePath.path);
      print("Converted WebP size: ${webpBytes?.length} bytes");
      if (webpBytes != null) {
        // Define the path for the new WebP file
        String webpPath = imagePath.path.replaceAll('.jpg', '.webp');
        File newFile = File(webpPath);

        // Write the WebP bytes to a new file
        await newFile.writeAsBytes(webpBytes);
        print('Image successfully converted and saved to $webpPath');

        final uploadedImg = await _uploadFile(newFile, doc);

        if (uploadedImg != null) {
          final currentList = [...state.documentsList];
          final newImages =
              uploadedImg.map<DocumentImage>((img) {
                return DocumentImage(
                  fileName: img['ldaDocName'] ?? '',
                  fileLocation: newFile.path,
                  docId: img['ldaDocId']?.toString() ?? '',
                  rowId: img['ldaRowId']?.toString() ?? '',
                );
              }).toList();

          // final List<DocumentImage> updatedImgs = [...doc.imgs, ...newImages];

          currentList[event.docIndex] = doc.copyWith(imgs: newImages);

          emit(
            state.copyWith(
              documentsList: currentList,
              fetchStatus: SubmitStatus.success,
              uploadMessage: "Uploaded Successfully",
            ),
          );
        } else {
          emit(
            state.copyWith(
              fetchStatus: SubmitStatus.failure,
              uploadMessage: "Upload failed",
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            fetchStatus: SubmitStatus.failure,
            uploadMessage: "WebP conversion failed",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.failure,
          uploadMessage: "Upload error: $e",
        ),
      );
    }
  }

  Future<dynamic> _uploadFile(File file, DocumentModel doc) async {
    UserDetails? userDetails = await loadUser();

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'userid': userDetails!.LPuserID,
        'proposalNumber': state.proposalNumber,
        'docid': '${doc.lpdDocId}${doc.lpdPartyId}',
        'partyType': doc.lpdPartyType,
        'docDesc': doc.lpdDocDesc,
        'token': ApiConfig.AUTH_TOKEN,
        'verticle': '7',
        'rowId': doc.lpdRowId,
      });

      final responseHandler = await UploadDocumentRepoImpl().uploadDoc(
        request: formData,
      );

      if (responseHandler.isRight()) {
        final response = responseHandler.right;
        final rawList = response['documentDetails'];
        if (rawList is List && rawList.isNotEmpty) {
          return rawList;
        } else {
          print("Upload succeeded but response has no documentdetails");
        }
      } else {
        print("Upload failed: ${responseHandler.left}");
        throw Exception("Upload failed: ${responseHandler.left}");
      }
    } catch (e) {
      print('_uploadFile: $e');
    }
  }

  Future<void> _onFetchDocumentImages(
    FetchDocumentImagesEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentList = [...state.documentsList];
    final doc = currentList[event.docIndex];
    UserDetails? userDetails = await loadUser();

    try {
      emit(state.copyWith(fetchStatus: SubmitStatus.loading));
      final responseHandler = await GetImageRepoImpl().fetchDocumentImage(
        request: {
          "userid": userDetails!.LPuserID,
          "rowId": doc.imgs[event.imgIndex].rowId,
          "token": ApiConfig.AUTH_TOKEN,
          "proposalNumber": state.proposalNumber,
        },
      );

      if (responseHandler.isRight()) {
        final response = responseHandler.right;
        final imgBase64 = response['file'] as String;
        if (imgBase64.isNotEmpty) {
          final imageBytes = base64Decode(imgBase64);
          final filename = '${response['agriDocumentDetails']['ldaDocName']}';
          final tempFile = await mediaService.saveBytesToFile(
            imageBytes,
            filename,
          );

          final docimg = DocumentImage(
            fileName: response['agriDocumentDetails']['ldaDocName'],
            fileLocation: tempFile.path, // saved filepath in local
            docId: response['agriDocumentDetails']['ldaDocId'].toString(),
            rowId: response['agriDocumentDetails']['ldaRowId'].toString(),
          );
          final updatedImgs = [...doc.imgs];
          updatedImgs[event.imgIndex] = docimg;

          final updatedDoc = doc.copyWith(imgs: updatedImgs);
          currentList[event.docIndex] = updatedDoc;
          emit(
            state.copyWith(
              documentsList: currentList,
              fetchStatus: SubmitStatus.success,
              uploadMessage: 'Fetched Successfully',
            ),
          );
        } else {
          print('imgBase64');
        }
      } else {
        emit(
          state.copyWith(
            fetchStatus: SubmitStatus.failure,
            uploadMessage: 'Fetched failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          fetchStatus: SubmitStatus.failure,
          uploadMessage: 'Fetched error! $e',
        ),
      );
      print(e);
    }
  }
}
