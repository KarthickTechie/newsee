import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_Image_delete_alert.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_file_sourece_selector.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_files_viewer.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../bloc/document_state.dart';

class DocumentList extends StatelessWidget {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        final bloc = context.read<DocumentBloc>();
        print("docs: ${state.borrowerDocs}");
        if (state.borrowerDocs.isEmpty) {
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

        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  children:
                      state.borrowerDocs.asMap().entries.map((entry) {
                        final index = entry.key;
                        final doc = entry.value;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      doc.prdDocDesc,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.blue,
                                    ),
                                    onPressed:
                                        bloc.disableBtn
                                            ? null
                                            : () => showFileSourceSelector(
                                              context,
                                              index,
                                              doc.prdDocDesc,
                                            ),
                                  ),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_red_eye),
                                        onPressed:
                                            doc.imgs.isEmpty
                                                ? null
                                                : () =>
                                                    showFilesViewerBottomSheet(
                                                      context,
                                                      index,
                                                      doc,
                                                    ),
                                      ),
                                      if (doc.imgs.isNotEmpty)
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '${doc.imgs.length}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed:
                                        bloc.disableBtn || doc.imgs.isEmpty
                                            ? null
                                            : () => confirmAndDeleteImage(
                                              context,
                                              index,
                                            ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.upload,
                                      color: Colors.green,
                                    ),
                                    onPressed:
                                        bloc.disableBtn || doc.imgs.isEmpty
                                            ? null
                                            : () {
                                              final doc =
                                                  state.borrowerDocs[index];
                                              final pendingIndexes = [
                                                for (
                                                  int i = 0;
                                                  i < doc.imgs.length;
                                                  i++
                                                )
                                                  if (doc.imgs[i].imgStatus ==
                                                          UploadStatus
                                                              .initial ||
                                                      doc.imgs[i].imgStatus ==
                                                          UploadStatus.failed)
                                                    i,
                                              ];

                                              if (pendingIndexes.isNotEmpty) {
                                                context
                                                    .read<DocumentBloc>()
                                                    .add(
                                                      UploadDocumentsEvent(
                                                        context: context,
                                                        docIndex: index,
                                                        imgIndex:
                                                            pendingIndexes,
                                                      ),
                                                    );
                                              }
                                            },
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey[50],
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
