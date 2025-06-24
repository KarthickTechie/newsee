import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newsee/feature/documentupload/domain/modal/document_model.dart';

void showFileViewerDialog(BuildContext context, List<DocumentImage> images) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text('Attached Files'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final file = images[index];
                final isImage = isImageFile(file.name);

                return ListTile(
                  leading: Icon(isImage ? Icons.image : Icons.picture_as_pdf),
                  title: Text(file.name),
                  subtitle: Text('${file.size.toStringAsFixed(1)} MB'),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
  );
}

bool isImageFile(String fileName) {
  final ext = fileName.toLowerCase();
  return ext.endsWith('.png') || ext.endsWith('.jpg') || ext.endsWith('.jpeg');
}
