import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Utils/pdf_viewer.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_state.dart';
import 'package:newsee/feature/documentupload/presentation/widget/image_view.dart';
import 'package:newsee/widgets/confirmation_delete_alert.dart';

class ShowFilesViewer extends StatelessWidget {
  final int docIndex;

  const ShowFilesViewer({super.key, required this.docIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        if (state.documentsList.length <= docIndex) {
          return const Center(child: Text("Invalid document"));
        }

        final doc = state.documentsList[docIndex];

        if (doc.imgs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'No images available.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: doc.imgs.length,
          itemBuilder: (context, imgIndex) {
            final image = doc.imgs[imgIndex];
            return ListTile(
              leading: const Icon(Icons.image),
              title: Text(image.fileName),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.blueGrey),
                onPressed: () async {
                  final confirmed = await confirmAndDeleteImage(context);
                  if (confirmed == true) {
                    context.read<DocumentBloc>().add(
                      DeleteDocumentImageEvent(
                        docIndex: docIndex,
                        imgIndex: imgIndex,
                      ),
                    );
                  }
                },
              ),
              onTap: () async {
                final bloc = context.read<DocumentBloc>();

                bloc.add(
                  FetchDocumentImagesEvent(
                    docIndex: docIndex,
                    imgIndex: imgIndex,
                  ),
                );

                final updatedDoc =
                    await bloc.stream
                        .where((state) {
                          final isLoaded =
                              state.fetchStatus == SubmitStatus.success;
                          final isValidDoc =
                              state.documentsList.length > docIndex;
                          final isValidImg =
                              isValidDoc &&
                              state.documentsList[docIndex].imgs.length >
                                  imgIndex;

                          if (!isLoaded || !isValidImg) return false;

                          final filePath =
                              state
                                  .documentsList[docIndex]
                                  .imgs[imgIndex]
                                  .fileLocation;
                          return filePath.isNotEmpty &&
                              File(filePath).existsSync();
                        })
                        .map((state) => state.documentsList[docIndex])
                        .first;
                print('$updatedDoc');
                final filePath = updatedDoc.imgs[imgIndex].fileLocation;
                final extension = filePath.split('.').last.toLowerCase();
                print('$filePath, $extension');
                if (context.mounted) {
                  if (extension == 'pdf') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // builder: (_) => PdfView(filePath: filePath),
                        builder:
                            (context) => PDFViewerFromBytes(filePath: filePath),
                      ),
                    );
                  } else {
                    final imageBytes = await File(filePath).readAsBytes();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: bloc,
                              child: ImageView(
                                imageBytes: imageBytes,
                                docIndex: docIndex,
                                isUploaded: true,
                                imgIndex: imgIndex,
                              ),
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
  }
}
