import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_Image_delete_alert.dart';
import 'package:provider/provider.dart';

void showFilesViewerBottomSheet(
  BuildContext context,
  // List<DocumentImage> images,
  int index,
  DocumentModel doc,
) {
  final bloc = context.read<DocumentBloc>();
  // final state = bloc.state;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (cxt) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Attached Files',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: doc.imgs.length,
                itemBuilder: (context, imgIndex) {
                  final file = doc.imgs[imgIndex];
                  final isImage = isImageFile(file.name);

                  return ListTile(
                    leading: Icon(isImage ? Icons.image : Icons.picture_as_pdf),
                    title: Text(file.name),
                    subtitle: Text('${file.size.toStringAsFixed(1)} MB'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.upload_rounded,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Uploading ${file.name}...'),
                              ),
                            );
                            bloc.add(
                              UploadDocumentsEvent(
                                context: context,
                                docIndex: index,
                                imgIndex: [imgIndex],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed:
                              bloc.disableBtn || doc.imgs.isEmpty
                                  ? null
                                  : () => {
                                    confirmAndDeleteImage(
                                      context,
                                      index,
                                      imgIndex: imgIndex,
                                      checkFrom: 'FileViewer',
                                    ),
                                    context.read<DocumentBloc>().add(
                                      DeleteDocEvent(
                                        docIndex: index,
                                        imgIndex: imgIndex,
                                      ),
                                    ), // trigger delete
                                  },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      if (isImage) {
                        showDialog(
                          context: context,
                          builder:
                              (_) => Dialog(child: Image.file(File(file.path))),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('PDF preview not implemented'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    },
  );
}

bool isImageFile(String fileName) {
  final ext = fileName.toLowerCase();
  return ext.endsWith('.png') || ext.endsWith('.jpg') || ext.endsWith('.jpeg');
}
