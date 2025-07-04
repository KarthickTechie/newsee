import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_state.dart';
import 'package:newsee/feature/documentupload/presentation/widget/image_view.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_file_sourece_selector.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_files_viewer.dart';

class DocumentList extends StatelessWidget {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        if (state.documentsList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 50),
                Icon(Icons.insert_drive_file, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  "No documents added yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.documentsList.length,
              itemBuilder: (context, index) {
                final doc = state.documentsList[index];
                return DocumentItem(doc: doc, index: index);
              },
            ),
          ),
        );
      },
    );
  }
}

class DocumentItem extends StatelessWidget {
  final DocumentModel doc;
  final int index;

  const DocumentItem({super.key, required this.doc, required this.index});

  @override
  Widget build(BuildContext context) {
    // final bool isSubmitted = doc.lpdDocAction == 'P';
    // final bool canEdit = !isSubmitted && (doc.lpdDocAction == 's');
    final bool hasImages = doc.imgs.isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  '${doc.lpdDocDesc}${doc.lpdManCheck == 'M' ? " *" : ""}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                onPressed:
                    () =>
                        showFileSourceSelector(context, index, doc.lpdDocDesc),
                // canEdit
                //     ? () => showFileSourceSelector(
                //       context,
                //       index,
                //       doc.lpdDocDesc,
                //     )
                //     : null,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () async {
                      // hasImages
                      //     ? () =>
                      //         showFilesViewerBottomSheet(context, index, doc)
                      //     : null,

                      // final bloc = context.read<DocumentBloc>();
                      // bloc.add(FetchDocumentImagesEvent(docIndex: index));

                      // // Wait for the state to finish loading
                      // final updatedState = await bloc.stream.firstWhere(
                      //   (state) => state.fetchStatus != SubmitStatus.loading,
                      // );

                      // final updatedDoc = updatedState.documentsList[index];

                      // if (updatedDoc.imgs.isNotEmpty) {
                      //   final filePath = updatedDoc.imgs.first.fileLocation;
                      //   final imageBytes = await File(filePath).readAsBytes();

                      //   if (context.mounted) {
                      //     await Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder:
                      //             (_) => ImageView(
                      //               imageBytes: imageBytes,
                      //               docIndex: index,
                      //               isUploaded: true,
                      //             ),
                      //       ),
                      //     );
                      //   }
                      // }
                      if (doc.imgs.isNotEmpty) {
                        final outerContext = context;
                        showModalBottomSheet(
                          context: outerContext,
                          builder: (_) {
                            return Builder(
                              // use Builder to get a new context under outerContext
                              builder: (sheetContext) {
                                return ListView.builder(
                                  itemCount: doc.imgs.length,
                                  itemBuilder: (context, imgIndex) {
                                    final image = doc.imgs[imgIndex];
                                    return ListTile(
                                      leading: const Icon(Icons.image),
                                      title: Text(image.fileName),
                                      onTap: () async {
                                        final bloc =
                                            outerContext.read<DocumentBloc>();
                                        bloc.add(
                                          FetchDocumentImagesEvent(
                                            docIndex: index,
                                            imgIndex: imgIndex,
                                          ),
                                        );

                                        // wait for the state to finish loading
                                        // final updatedState = await bloc.stream
                                        //     .firstWhere(
                                        //       (state) =>
                                        //           state.fetchStatus !=
                                        //           SubmitStatus.loading,
                                        //     );

                                        final updatedDoc =
                                            await bloc.stream
                                                .where((state) {
                                                  final isLoaded =
                                                      state.fetchStatus ==
                                                      SubmitStatus.success;
                                                  final isDocValid =
                                                      state
                                                          .documentsList
                                                          .length >
                                                      index;
                                                  if (!isLoaded || !isDocValid)
                                                    return false;

                                                  final updatedImageList =
                                                      state
                                                          .documentsList[index]
                                                          .imgs;
                                                  final isImageValid =
                                                      updatedImageList.length >
                                                      imgIndex;

                                                  if (!isImageValid)
                                                    return false;

                                                  final fileLocation =
                                                      updatedImageList[imgIndex]
                                                          .fileLocation;
                                                  return fileLocation
                                                          .isNotEmpty &&
                                                      File(
                                                        fileLocation,
                                                      ).existsSync();
                                                })
                                                .map(
                                                  (state) =>
                                                      state
                                                          .documentsList[index],
                                                )
                                                .first;

                                        // final updatedDoc =
                                        //     updatedState.documentsList[index];
                                        print('doclist: $updatedDoc');
                                        if (updatedDoc.imgs.isNotEmpty &&
                                            sheetContext.mounted) {
                                          final filePath =
                                              updatedDoc
                                                  .imgs
                                                  .first
                                                  .fileLocation;
                                          // Navigator.of(
                                          //   sheetContext,
                                          // ).pop(); // close bottom sheet
                                          final imageBytes =
                                              await File(
                                                filePath,
                                              ).readAsBytes();
                                          if (sheetContext.mounted) {
                                            Navigator.of(outerContext).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => ImageView(
                                                      imageBytes: imageBytes,
                                                      docIndex: index,
                                                      isUploaded: true,
                                                    ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                  if (hasImages)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${doc.imgs.length}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // IconButton(
              //   icon: const Icon(Icons.delete, color: Colors.redAccent),
              //   onPressed:
              //       canEdit && hasImages
              //           ? () => confirmAndDeleteImage(context, index)
              //           : null,
              // ),
              // IconButton(
              //   icon: const Icon(Icons.upload, color: Colors.green),
              //   onPressed:
              //       canEdit && hasImages
              //           ? () {
              //             final pendingIndexes = [
              //               for (int i = 0; i < doc.imgs.length; i++)
              //                 if (doc.imgs[i].imgStatus ==
              //                         UploadStatus.initial ||
              //                     doc.imgs[i].imgStatus == UploadStatus.failed)
              //                   i,
              //             ];
              //             if (pendingIndexes.isNotEmpty) {
              //               context.read<DocumentBloc>().add(
              //                 UploadDocumentByIndexEvent(
              //                   docIndex: index,
              //                   imgIndexes: pendingIndexes,
              //                 ),
              //               );
              //             }
              //           }
              //           : null,
              // ),
              // if (isSubmitted)
              //   const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey[200]),
      ],
    );
  }
}
